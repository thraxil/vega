defmodule Vega.SiteTest do
  use Vega.DataCase

  alias Vega.Site

  describe "users" do
    @valid_attrs %{
      username: "anders",
      fullname: "anders",
      email: "test@example.com",
      bio: "a non-blank bio"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Site.user_create()

      user
    end

    test "list_users/0 returns empty when no users" do
      assert Site.list_users() == []
    end

    test "list_users/0 returns created user" do
      user = user_fixture()
      assert Site.list_users() == [user]
    end

    test "get_user!/1 returns expected user" do
      user = user_fixture()
      r = Site.get_user!(user.username)
      assert user == r
    end
  end

  describe "nodes" do
    test "count_posts/0 is zero when no posts" do
      assert Site.count_posts() == 0
    end

    test "newest_nodes/0 is empty when no posts" do
      assert Site.newest_nodes() == []
    end

    test "newest_posts/2 is empty when no posts" do
      assert Site.newest_posts() == []
    end

    test "user_count_posts/1 is zero when no posts" do
      user = user_fixture()
      assert Site.user_count_posts(user) == 0
    end

    test "user_newest_posts/1 is empty when no posts" do
      user = user_fixture()
      assert Site.user_newest_posts(user) == []
    end

    test "user_type_years/2 is empty when no posts" do
      user = user_fixture()
      assert Site.user_type_years(user, "post") == []
    end

    test "user_type_year_months/3 is empty when no posts" do
      user = user_fixture()
      assert Site.user_type_year_months(user, "post", "2023") == []
    end

    test "user_type_year_month_days/4 is empty when no posts" do
      user = user_fixture()
      assert Site.user_type_year_month_days(user, "post", "2023", "1") == []
    end

    test "user_type_year_month_day/5 is empty when no posts" do
      user = user_fixture()
      assert Site.user_type_year_month_day(user, "post", "2023", "1", "1") == []
    end

    test "search/1 returns no results when no posts" do
      assert Site.search("foo") == []
    end

    test "add_post/3 creates post" do
      user = user_fixture()
      {:ok, node} = Site.add_post("title", "body", "tagone tagtwo")
      assert Site.count_posts() == 1
      newest = Site.newest_posts()
      assert length(newest) == 1
      assert node.id == hd(newest).id
      assert length(Site.user_newest_posts(user)) == 1
      assert Site.user_count_posts(user) == 1
    end
  end
end
