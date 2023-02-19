defmodule VegaWeb.PageController do
  use VegaWeb, :controller
  alias Vega.Site
  require OpenTelemetry.Tracer, as: Tracer

  def index(conn, _params) do
    Tracer.with_span "index" do
      posts_per_page = 10
      defaults = %{"page" => "1"}
      params = Map.merge(defaults, conn.query_params)
      {page, _} = Integer.parse(params["page"])
      posts_count = Site.count_posts()
      max_page = div(posts_count, posts_per_page) + 1
      nodes = Site.newest_posts(posts_per_page, min(page, max_page))
      has_next = page * posts_per_page <= posts_count

      Tracer.with_span "render" do
        render(
          conn,
          "index.html",
          nodes: nodes,
          page: min(page, max_page),
          prev_page: max(page - 1, 1),
          has_prev: page > 1,
          next_page: page + 1,
          has_next: has_next
        )
      end
    end
  end

  def node_detail(conn, %{
        "username" => username,
        "type" => type,
        "year" => year,
        "month" => month,
        "day" => day,
        "slug" => slug
      }) do
    user = Site.get_user!(username)
    type = String.replace_suffix(type, "s", "")
    node = Site.get_node!(user, type, year, month, day, slug)
    content = Site.get_node_content!(node)

    render(conn, "node_detail.html",
      user: user,
      node: node,
      type: type,
      year: year,
      month: month,
      day: day,
      slug: slug,
      content: content
    )
  end

  def edit_node(conn, %{"id" => node_id, "node" => node_params} = params) do
    node = Site.get_node_by_id!(node_id)

    case Site.update_node(node, node_params) do
      {:ok, node} ->
        conn
        |> put_flash(:info, "updated")
        |> redirect(to: Routes.page_path(conn, :show_node, node_id))

      {:error, changeset} ->
        type = node.type
        content = Site.get_node_content!(node)

        render(conn, "show_node.html",
          changeset: changeset,
          node: node,
          type: type,
          content: content
        )
    end
  end

  def show_node(conn, %{"id" => node_id}) do
    node = Site.get_node_by_id!(node_id)
    type = node.type
    content = Site.get_node_content!(node)

    node_changeset = Site.node_changeset(node)

    render(conn, "show_node.html",
      changeset: node_changeset,
      node: node,
      type: type,
      content: content
    )
  end

  def tag_detail(conn, %{"slug" => slug}) do
    tag = Site.get_tag!(slug)
    render(conn, "tag_detail.html", tag: tag)
  end

  def tag_index(conn, _params) do
    tags = Site.list_tags()
    render(conn, "tag_index.html", tags: tags)
  end

  def user_detail(conn, %{"username" => username}) do
    user = Site.get_user!(username)

    posts_per_page = 10
    defaults = %{"page" => "1"}
    params = Map.merge(defaults, conn.query_params)
    {page, _} = Integer.parse(params["page"])
    posts_count = Site.user_count_posts(user)
    max_page = div(posts_count, posts_per_page) + 1
    nodes = Site.user_newest_posts(user, posts_per_page, min(page, max_page))
    has_next = page * posts_per_page <= posts_count

    render(
      conn,
      "user_detail.html",
      user: user,
      nodes: nodes,
      page: min(page, max_page),
      prev_page: max(page - 1, 1),
      has_prev: page > 1,
      next_page: page + 1,
      has_next: has_next
    )
  end

  def user_type_index(conn, %{"username" => username, "type" => type}) do
    user = Site.get_user!(username)
    type = String.replace_suffix(type, "s", "")
    years = Site.user_type_years(user, type)
    render(conn, "user_type_index.html", user: user, type: type, years: years)
  end

  def user_type_year_index(conn, %{"username" => username, "type" => type, "year" => year}) do
    user = Site.get_user!(username)
    type = String.replace_suffix(type, "s", "")
    months = Site.user_type_year_months(user, type, year)
    render(conn, "user_type_year_index.html", user: user, type: type, year: year, months: months)
  end

  def user_type_year_month_index(conn, %{
        "username" => username,
        "type" => type,
        "year" => year,
        "month" => month
      }) do
    user = Site.get_user!(username)
    type = String.replace_suffix(type, "s", "")
    days = Site.user_type_year_month_days(user, type, year, month)

    render(conn, "user_type_year_month_index.html",
      user: user,
      type: type,
      year: year,
      month: month,
      days: days
    )
  end

  def user_type_year_month_day_index(conn, %{
        "username" => username,
        "type" => type,
        "year" => year,
        "month" => month,
        "day" => day
      }) do
    user = Site.get_user!(username)
    type = String.replace_suffix(type, "s", "")
    nodes = Site.user_type_year_month_day(user, type, year, month, day)

    render(conn, "user_type_year_month_day_index.html",
      user: user,
      type: type,
      year: year,
      month: month,
      day: day,
      nodes: nodes
    )
  end

  def user_index(conn, _params) do
    users = Site.list_users()
    render(conn, "user_index.html", users: users)
  end

  def search_results(conn, _params) do
    defaults = %{"q" => ""}
    params = Map.merge(defaults, conn.query_params)
    q = params["q"]
    nodes = Site.search(q)
    render(conn, "search_results.html", nodes: nodes, q: q)
  end
end
