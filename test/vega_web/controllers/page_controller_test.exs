defmodule VegaWeb.PageControllerTest do
  use VegaWeb.ConnCase

  import Vega.SiteFixtures

  describe "empty database" do
    test "renders empty index", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ "thraxil.org"
    end

    test "smoketest", %{conn: conn} do
      conn = get(conn, "/smoketest/")
      response = response(conn, 200)
      assert response =~ "PASS"
    end

    test "healthz", %{conn: conn} do
      conn = get(conn, "/healthz")
      response = response(conn, 200)
      assert response == ""
    end
  end

  describe "single post created" do
    setup [:with_post]

    test "node shows up in index", %{conn: conn, node: node} do
      conn = get(conn, Routes.page_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ "thraxil.org"
      assert response =~ node.title
      assert response =~ "<p>\ntest body</p>"
    end

    test "node shows up in user index", %{conn: conn, node: node, user: user} do
      conn = get(conn, Routes.page_path(conn, :user_detail, user.username))
      response = html_response(conn, 200)
      assert response =~ user.fullname
      assert response =~ node.title
      assert response =~ "<p>\ntest body</p>"
    end

    test "node shows up in user type index", %{conn: conn, user: user} do
      conn = get(conn, Routes.page_path(conn, :user_type_index, user.username, "posts"))
      response = html_response(conn, 200)
      assert response =~ "<li>"
    end

    test "invalid user type is 404", %{conn: conn, user: user} do
      conn = get(conn, Routes.page_path(conn, :user_type_index, user.username, "blahs"))
      response = response(conn, 404)
      assert response =~ "invalid type"
    end

    test "node shows up in user type year index", %{conn: conn, node: node, user: user} do
      year = VegaWeb.PageView.node_year(node)

      conn =
        get(conn, Routes.page_path(conn, :user_type_year_index, user.username, "posts", year))

      response = html_response(conn, 200)
      assert response =~ "<li>"
    end

    test "node shows up in user type year month index", %{conn: conn, node: node, user: user} do
      year = VegaWeb.PageView.node_year(node)
      month = VegaWeb.PageView.node_month(node)

      conn =
        get(
          conn,
          Routes.page_path(conn, :user_type_year_month_index, user.username, "posts", year, month)
        )

      response = html_response(conn, 200)
      assert response =~ "<li>"
    end

    test "node shows up in user type year month day index", %{conn: conn, node: node, user: user} do
      year = VegaWeb.PageView.node_year(node)
      month = VegaWeb.PageView.node_month(node)
      day = VegaWeb.PageView.node_day(node)

      conn =
        get(
          conn,
          Routes.page_path(
            conn,
            :user_type_year_month_day_index,
            user.username,
            "posts",
            year,
            month,
            day
          )
        )

      response = html_response(conn, 200)
      assert response =~ "<li>"
    end

    test "node shows up in search results", %{conn: conn, node: node, user: user} do
      conn = get(conn, Routes.page_path(conn, :search_results, %{q: "test"}))
      response = html_response(conn, 200)
      assert response =~ user.fullname
      assert response =~ node.title
    end

    test "node detail page", %{conn: conn, node: node, user: user} do
      path = VegaWeb.PageView.node_path(node)
      assert path =~ node.slug
      conn = get(conn, path)
      response = html_response(conn, 200)
      assert response =~ user.fullname
      assert response =~ node.title
      assert response =~ "<p>\ntest body</p>"
    end

    test "node shows up in tag page", %{conn: conn, node: node} do
      conn = get(conn, Routes.page_path(conn, :tag_detail, "tagone"))
      response = html_response(conn, 200)
      assert response =~ node.title
    end

    test "tag index has expected entries", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :tag_index))
      response = html_response(conn, 200)
      assert response =~ "tagone"
      assert response =~ "tagtwo"
    end

    test "user index has expected user", %{conn: conn, user: user} do
      conn = get(conn, Routes.page_path(conn, :user_index))
      response = html_response(conn, 200)
      assert response =~ user.fullname
    end

    test "invalid type doesn't cause server error", %{conn: conn, user: user} do
      # requests for /users/anders/feeds/atom.xml was being
      # misinterpreted as a 'feed' type and breaking
      conn = get(conn, "/users/" <> user.username <> "/feeds/atom.xml")
      response = response(conn, 404)
      assert response =~ "invalid type"
    end
  end
end
