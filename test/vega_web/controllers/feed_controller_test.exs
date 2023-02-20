defmodule VegaWeb.FeedControllerTest do
  use VegaWeb.ConnCase

  import Vega.SiteFixtures

  describe "empty database" do
    test "renders empty feed", %{conn: conn} do
      conn = get(conn, Routes.rss_path(conn, :index))
      response = response(conn, 200)
      assert response =~ "thraxil.org"
    end
  end

  describe "single post created" do
    setup [:with_post]

    test "node shows up in index", %{conn: conn, node: node} do
      conn = get(conn, Routes.rss_path(conn, :index))
      response = response(conn, 200)
      assert response =~ "thraxil.org"
      assert response =~ node.title
      assert response =~ "&lt;p&gt;\ntest body&lt;/p&gt;"
    end

    test "node shows up in user index", %{conn: conn, node: node, user: user} do
      conn = get(conn, Routes.rss_path(conn, :user_index, user.username))
      response = response(conn, 200)
      assert response =~ user.fullname
      assert response =~ node.title
      assert response =~ "&lt;p&gt;\ntest body&lt;/p&gt;"
    end
  end
end
