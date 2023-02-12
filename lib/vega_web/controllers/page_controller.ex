defmodule VegaWeb.PageController do
  use VegaWeb, :controller
  alias Vega.Site

  def index(conn, _params) do
    render(conn, "index.html")
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
    render(conn, "node_detail.html", user: user, node: node)
  end
end
