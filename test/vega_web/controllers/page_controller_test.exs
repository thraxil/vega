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

  describe "authenticated views" do
    setup [:register_and_log_in_user, :with_post]

    test "add post form", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :new_post))
      response = html_response(conn, 200)
      assert response =~ "<form"
      assert response =~ "<textarea"
    end

    test "add post", %{conn: conn} do
      conn =
        post(conn, Routes.page_path(conn, :create_post),
          node: %{title: "new title", body: "new body", node_tags: "tag1 tag0 tag0"}
        )

      # should redirect to edit page upon creation
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.page_path(conn, :show_node, id)
      assert get_flash(conn, :info) =~ "created"

      node_from_db = Vega.Repo.get(Vega.Node, id)

      assert node_from_db.title == "new title"
      assert node_from_db.type == "post"
      assert node_from_db.status == "Publish"

      content = Vega.Site.get_node_content!(node_from_db)
      assert content.body == "new body"
      assert content.body_html == "<p>\nnew body</p>\n"

      tags = Vega.Site.get_node_tags_string(node_from_db)
      assert tags == "tag0 tag1"
    end

    test "edit post form", %{conn: conn, node: node} do
      conn = get(conn, Routes.page_path(conn, :show_node, node.id))
      response = html_response(conn, 200)
      assert response =~ "<form"
      assert response =~ "<textarea"
      assert response =~ "value=\"" <> node.title <> "\""
    end

    test "edit post", %{conn: conn, node: node} do
      conn =
        put(conn, Routes.page_path(conn, :edit_node, node.id),
          node: %{title: "new title", body: "new body", tags: "tag1 tag0 tag0"}
        )

      # should redirect to edit page upon creation
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.page_path(conn, :show_node, id)
      assert get_flash(conn, :info) =~ "updated"

      node_from_db = Vega.Repo.get(Vega.Node, id)

      assert node_from_db.title == "new title"
      assert node_from_db.type == "post"
      assert node_from_db.status == "Publish"

      content = Vega.Site.get_node_content!(node_from_db)
      assert content.body == "new body"
      assert content.body_html == "<p>\nnew body</p>\n"

      tags = Vega.Site.get_node_tags_string(node_from_db)
      assert tags == "tag0 tag1"
    end
  end
end
