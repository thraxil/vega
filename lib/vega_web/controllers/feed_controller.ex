defmodule VegaWeb.RssController do
  use VegaWeb, :controller

  alias Vega.Site
  alias Atomex.{Feed, Entry}

  @author "Anders Pearson"
  @email "anders@thraxil.org"
  @base "https://thraxil.org/"
  @title "Thraxil"

  def index(conn, _params) do
    posts = Site.newest_posts(10, 1)
    link = Routes.rss_url(conn, :index)
    feed = build_feed(@base, @title, @author, @email, link, posts, conn)

    conn
    |> put_resp_content_type("text/xml")
    |> send_resp(200, feed)
  end

  def build_feed(base, title, author, email, link, posts, conn) do
    Feed.new(base, DateTime.utc_now(), title)
    |> Feed.author(author, email: email)
    |> Feed.link(link, rel: "self")
    |> Feed.entries(Enum.map(posts, &get_entry(conn, &1)))
    |> Feed.build()
    |> Atomex.generate_document()
  end

  defp get_entry(_conn, node) do
    Entry.new(
      VegaWeb.PageView.node_path(node),
      DateTime.from_naive!(node.created, "Etc/UTC"),
      node.title
    )
    |> Entry.link(VegaWeb.PageView.node_path(node))
    |> Entry.author(@author)
    |> Entry.content(Earmark.as_html!(node.body), type: "html")
    |> Entry.build()
  end

  def user_index(conn, %{"username" => username}) do
    user = Site.get_user!(username)
    link = Routes.rss_url(conn, :user_index, username)
    posts = Site.user_newest_posts(user, 10, 1)

    feed =
      build_feed(
        @base <> "users/" <> user.username <> "/",
        "Thraxil feed for " <> user.fullname,
        user.fullname,
        user.email,
        link,
        posts,
        conn
      )

    conn
    |> put_resp_content_type("text/xml")
    |> send_resp(200, feed)
  end
end
