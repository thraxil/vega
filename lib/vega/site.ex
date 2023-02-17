defmodule Vega.Site do
  @moduledoc """
  The Site context.
  """

  import Ecto.Changeset, only: [change: 2]
  import Ecto.Query, warn: false
  require OpenTelemetry.Tracer, as: Tracer

  alias Vega.Repo
  alias Vega.User
  alias Vega.Node
  alias Vega.Post
  alias Vega.Image
  alias Vega.Bookmark
  alias Vega.Tag

  def get_user!(username) do
    Repo.get_by!(User, username: username)
  end

  def list_users() do
    Repo.all(from u in User, order_by: [asc: u.fullname])
  end

  defp created_str(year, month, day) do
    (year |> Integer.to_string() |> String.pad_leading(4, "0")) <>
      "-" <>
      (month |> Integer.to_string() |> String.pad_leading(2, "0")) <>
      "-" <> (day |> Integer.to_string() |> String.pad_leading(2, "0"))
  end

  def get_node!(user, type, year, month, day, slug) do
    created = %Date{
      year: String.to_integer(year),
      month: String.to_integer(month),
      day: String.to_integer(day)
    }

    q =
      from n in Node,
        where:
          n.user_id == ^user.id and
            n.type == ^type and
            n.slug == ^slug and
            n.status == "Publish" and
            fragment("?::date", n.created) == ^created

    Repo.one!(q)
    |> Repo.preload(:user)
    |> Repo.preload(:comments)
    |> Repo.preload(:tags)
    |> Repo.preload(:fields)
  end

  defp _get_node_c!(node, c) do
    q =
      from p in c,
        where: p.node_id == ^node.id,
        order_by: [desc: :version],
        limit: 1

    Repo.one!(q)
  end

  def get_node_content!(node = %Node{:type => "post"}) do
    _get_node_c!(node, Post)
  end

  def get_node_content!(node = %Node{:type => "image"}) do
    _get_node_c!(node, Image)
  end

  def get_node_content!(node = %Node{:type => "bookmark"}) do
    _get_node_c!(node, Bookmark)
  end

  def get_tag!(slug) do
    Repo.one!(
      from tag in Tag,
        where: tag.slug == ^slug,
        left_join: nodes in assoc(tag, :nodes),
        left_join: user in assoc(nodes, :user),
        preload: [nodes: {nodes, user: user}]
    )
  end

  def list_tags() do
    Repo.all(from t in Tag, order_by: [asc: t.name])
  end

  def newest_nodes() do
    Repo.all(
      from n in Node,
        where: n.type == "post" and n.status == "Publish",
        order_by: [desc: n.created],
        limit: 10
    )
    |> Repo.preload(:user)
    |> Repo.preload(:comments)
  end

  def count_posts() do
    Repo.one(
      from n in Node,
        select: count(n.id),
        where: n.type == "post" and n.status == "Publish"
    )
  end

  def user_count_posts(user) do
    Tracer.with_span "Site.user_count_posts/1" do
      Tracer.set_attributes([{:username, user.username}])
      Tracer.set_attributes([{:user_id, user.id}])

      Repo.one(
        from n in Node,
          select: count(n.id),
          where: n.user_id == ^user.id and n.type == "post" and n.status == "Publish"
      )
    end
  end

  defp post_versions_q() do
    from p in Post,
      group_by: p.node_id,
      select: %{
        node_id: p.node_id,
        max_version_id: max(p.id)
      }
  end

  def newest_posts(per_page \\ 10, page \\ 1) do
    offset = per_page * (page - 1)

    Repo.all(
      from p in Post,
        join: last in subquery(post_versions_q()),
        on: last.max_version_id == p.id,
        join: n in assoc(p, :node),
        join: u in assoc(n, :user),
        where: n.type == "post" and n.status == "Publish",
        order_by: [desc: n.created],
        limit: ^per_page,
        offset: ^offset,
        select: %{
          id: n.id,
          type: n.type,
          slug: n.slug,
          title: n.title,
          created: n.created,
          user: u,
          body: p.body
        }
    )
  end

  def user_newest_posts(user, per_page \\ 10, page \\ 1) do
    Tracer.with_span "Site.user_newest_posts/3" do
      Tracer.set_attributes([{:username, user.username}])
      Tracer.set_attributes([{:per_page, per_page}])
      Tracer.set_attributes([{:page, page}])
      offset = per_page * (page - 1)

      Repo.all(
        from p in Post,
          join: last in subquery(post_versions_q()),
          on: last.max_version_id == p.id,
          join: n in assoc(p, :node),
          join: u in assoc(n, :user),
          where: n.user_id == ^user.id and n.type == "post" and n.status == "Publish",
          order_by: [desc: n.created],
          limit: ^per_page,
          offset: ^offset,
          select: %{
            id: n.id,
            type: n.type,
            slug: n.slug,
            title: n.title,
            created: n.created,
            user: u,
            body: p.body
          }
      )
    end
  end

  def user_type_years(user, type) do
    Repo.all(
      from n in Node,
        where: n.user_id == ^user.id and n.type == ^type and n.status == "Publish",
        group_by: [fragment("year")],
        select: %{
          year: fragment("date_part('YEAR', ?) as year", n.created),
          count: count(n.id)
        },
        order_by: [desc: fragment("year")]
    )
  end

  def user_type_year_months(user, type, year) do
    year = String.to_integer(year)

    Repo.all(
      from n in Node,
        where:
          n.user_id == ^user.id and
            n.type == ^type and
            n.status == "Publish" and
            fragment("date_part('YEAR', ?)", n.created) == ^year,
        group_by: [fragment("month")],
        select: %{
          month: fragment("date_part('MONTH', ?) as month", n.created),
          count: count(n.id)
        },
        order_by: [asc: fragment("month")]
    )
  end

  def user_type_year_month_days(user, type, year, month) do
    year = String.to_integer(year)
    month = String.to_integer(month)

    Repo.all(
      from n in Node,
        where:
          n.user_id == ^user.id and
            n.type == ^type and
            n.status == "Publish" and
            fragment("date_part('YEAR', ?)", n.created) == ^year and
            fragment("date_part('MONTH', ?)", n.created) == ^month,
        group_by: [fragment("day")],
        select: %{
          day: fragment("date_part('DAY', ?) as day", n.created),
          count: count(n.id)
        },
        order_by: [asc: fragment("day")]
    )
  end

  def user_type_year_month_day(user, type, year, month, day) do
    year = String.to_integer(year)
    month = String.to_integer(month)
    day = String.to_integer(day)

    Repo.all(
      from n in Node,
        where:
          n.user_id == ^user.id and
            n.type == ^type and
            n.status == "Publish" and
            fragment("date_part('YEAR', ?)", n.created) == ^year and
            fragment("date_part('MONTH', ?)", n.created) == ^month and
            fragment("date_part('DAY', ?)", n.created) == ^day,
        order_by: n.created
    )
    |> Repo.preload(:user)
  end

  def search(q) do
    q = "%" <> q <> "%"

    # any nodes with a match in the title
    title_matches =
      Repo.all(
        from n in Node,
          where: ilike(n.title, ^q),
          order_by: [desc: n.created]
      )

    # individually search posts, images, and bookmarks
    post_matches =
      Repo.all(
        from p in Post,
          where: ilike(p.body, ^q)
      )
      |> Repo.preload(:node)

    bookmark_matches =
      Repo.all(
        from b in Bookmark,
          where: ilike(b.description, ^q)
      )
      |> Repo.preload(:node)

    image_matches =
      Repo.all(
        from i in Image,
          where: ilike(i.description, ^q)
      )
      |> Repo.preload(:node)

    # merge them all back together, pulling out the node for each post/image/bookmark
    combined =
      title_matches ++
        Enum.map(post_matches ++ bookmark_matches ++ image_matches, fn p -> p.node end)

    # remove duplicates, sort (outside the database: boo), and preload
    combined
    |> Enum.uniq()
    |> Enum.sort(&(to_string(&1.created) >= to_string(&2.created)))
    |> Repo.preload(:user)
    |> Repo.preload(:tags)
  end
end
