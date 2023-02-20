defmodule Vega.SiteFixtures do
  alias Vega.Site
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(
      attrs,
      %{
        username: "anders",
        email: unique_user_email(),
        fullname: "anders",
        bio: "a non-blank bio"
      }
    )
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Site.user_create()

    user
  end

  def with_post(context) do
    user = user_fixture()
    {:ok, node} = Site.add_post("test post", "test body", "tagone tagtwo")
    Map.put(context, :user, user) |> Map.put(:node, node)
  end
end
