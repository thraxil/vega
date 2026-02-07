defmodule Vega.Site do
  @moduledoc """
  The Site context.
  """

  import Ecto.Query, warn: false

  alias Vega.Repo
  alias Vega.User
  alias Vega.Node
  alias Vega.Blog.Post
  alias Vega.Image
  alias Vega.Library.Bookmark
  alias Vega.Taxonomy.Tag

  def user_create(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user!(username) do
    Repo.get_by!(User, username: username)
  end

  def list_users() do
    User
    |> order_by([u], asc: u.fullname)
    |> Repo.all()
  end

  def get_node_by_id!(node_id) do
    Repo.get!(Node, node_id)
  end

  def update_node(node, node_params) do
    node_params = Map.put(node_params, "modified", DateTime.utc_now())

    node
    |> Node.changeset(node_params)
    |> Repo.update!()
    |> node_add_post(node_params["body"])

    node_add_tags(node, node_params["tags"])

    {:ok, node}
  end

  def node_post_count(node) do
    Repo.one(
      from p in Post,
        select: count(p.id),
        where: p.node_id == ^node.id
    )
  end

  def node_add_post(node, body) do
    next_version = node_post_count(node) + 1

    %Post{}
    |> Post.changeset(%{
      "modified" => DateTime.utc_now(),
      "body" => body,
      "version" => next_version
    })
    |> Ecto.Changeset.put_assoc(:node, node)
    |> Repo.insert()
  end

  def node_add_tags(node, tags) do
    tags =
      Node.parse_tags(tags)
      |> Enum.map(fn t ->
        get_or_insert_tag(t)
      end)

    node
    |> Repo.preload(:tags)
    |> Node.changeset(%{})
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.update()
  end

  def get_or_insert_tag(t) do
    %{:name => name, :slug => slug} = t

    Repo.get_by(Tag, slug: slug) ||
      Repo.insert!(%Tag{name: name, slug: slug})
  end

  # defp get_or_insert_tag(name, slug) do
  #   Repo.insert!(
  #     %Vega.Taxonomy.Tag{name: name, slug: slug},
  #     on_conflict: [set: [name: name, slug: slug]],
  #     conflict_target: [:name, :slug]
  #   )
  # end

  def get_node!(user, type, year, month, day, slug) do
    created = %Date{
      year: String.to_integer(year),
      month: String.to_integer(month),
      day: String.to_integer(day)
    }

    Node
    |> Node.by_user(user)
    |> Node.by_type(type)
    |> Node.published()
    |> Node.by_slug(slug)
    |> Node.by_date(created)
    |> first()
    |> Repo.one!()
    |> Repo.preload(:user)
    |> Repo.preload(:comments)
    |> Repo.preload(:tags)
    |> Repo.preload(:fields)
  end

  defp _get_node_c!(node, c) do
    c
    |> where([p], p.node_id == ^node.id)
    |> order_by([p], desc: p.version)
    |> limit(1)
    |> Repo.one!()
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
    Tag
    |> order_by([t], asc: t.name)
    |> Repo.all()
  end

  def newest_nodes() do
    Node
    |> Node.by_type("post")
    |> Node.published()
    |> order_by([n], desc: n.created)
    |> limit(10)
    |> Repo.all()
    |> Repo.preload(:user)
    |> Repo.preload(:comments)
  end

  def count_posts() do
    Node
    |> Node.by_type("post")
    |> Node.published()
    |> select([n], count(n.id))
    |> Repo.one()
  end

  def count_users() do
    User
    |> select([u], count(u.id))
    |> Repo.one()
  end

  def user_count_posts(user) do
    Node
    |> Node.by_user(user)
    |> Node.by_type("post")
    |> Node.published()
    |> select([n], count(n.id))
    |> Repo.one()
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
          body: p.body,
          body_html: p.body_html
        }
    )
  end

  def user_newest_posts(user, per_page \\ 10, page \\ 1) do
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
          body: p.body,
          body_html: p.body_html
        }
    )
  end

  def user_type_years(user, type) do
    nodes =
      Node
      |> Node.by_user(user)
      |> Node.by_type(type)
      |> Node.published()

    Repo.all(
      from n in nodes,
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

    nodes =
      Node
      |> Node.by_user(user)
      |> Node.by_type(type)
      |> Node.published()
      |> Node.by_year(year)

    Repo.all(
      from n in nodes,
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

    nodes =
      Node
      |> Node.by_user(user)
      |> Node.by_type(type)
      |> Node.published()
      |> Node.by_year(year)
      |> Node.by_month(month)

    Repo.all(
      from n in nodes,
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

    Node
    |> Node.by_user(user)
    |> Node.by_type(type)
    |> Node.published()
    |> Node.by_year(year)
    |> Node.by_month(month)
    |> Node.by_day(day)
    |> order_by([n], n.created)
    |> Repo.all()
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

  def node_changeset(node) do
    Node.changeset(node)
  end

  def get_node_tags_string(node) do
    node =
      node
      |> Repo.preload(:tags)

    node.tags |> Enum.map(fn t -> t.name end) |> Enum.sort() |> Enum.join(" ")
  end

  def node_create_changeset() do
    node_changeset(%Node{})
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  defp get_default_user() do
    # hard-coded to `anders`, the only user
    # that is still allowed to create posts
    # TODO: make this work for tests
    Repo.get_by!(User, username: "anders")
  end

  def add_post(title, body, tags) do
    now = DateTime.utc_now()
    user = get_default_user()

    node_params = %{
      :title => title,
      :created => now,
      :modified => now,
      :slug => slugify(title)
    }

    node = %Node{
      :type => "post",
      :status => "Publish",
      :comments_allowed => false
    }

    {:ok, node} =
      node
      |> Node.changeset(node_params)
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()

    node_add_post(node, body)
    node_add_tags(node, tags)

    {:ok, node}
  end
end
