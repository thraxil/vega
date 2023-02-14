defmodule VegaWeb.PageController do
  use VegaWeb, :controller
  alias Vega.Site

  def index(conn, _params) do
    posts_per_page = 10
    defaults = %{"page" => "1"}
    params = Map.merge(defaults, conn.query_params)
    {page, _} = Integer.parse(params["page"])
    posts_count = Site.count_posts()
    max_page = div(posts_count, posts_per_page) + 1
    nodes = Site.newest_posts(posts_per_page, min(page, max_page))
    has_next = page * posts_per_page <= posts_count

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
    render(conn, "user_detail.html", user: user)
  end

  def user_index(conn, _params) do
    users = Site.list_users()
    render(conn, "user_index.html", users: users)
  end
end
