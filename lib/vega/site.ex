defmodule Vega.Site do
  @moduledoc """
  The Site context.
  """

  import Ecto.Changeset, only: [change: 2]
  import Ecto.Query, warn: false
  alias Vega.Repo

  alias Vega.User
  alias Vega.Node

  def get_user!(username) do
    Repo.get_by(User, username: username)
  end

  defp created_str(year, month, day) do
    (year |> Integer.to_string() |> String.pad_leading(4, "0")) <>
      "-" <>
      (month |> Integer.to_string() |> String.pad_leading(2, "0")) <>
      "-" <> (day |> Integer.to_string() |> String.pad_leading(2, "0"))
  end

  def get_node!(user, type, year, month, day, slug) do
    created = %Date{
      year: String.to_integer(year),
      month: String.to_integer(month),
      day: String.to_integer(day)
    }

    q =
      from n in Node,
        where:
          n.user_id == ^user.id and
            n.type == ^type and
            n.slug == ^slug and
            n.status == "Publish" and
            fragment("?::date", n.created) == ^created

    Repo.one!(q)
    |> Repo.preload(:user)
    |> Repo.preload(:comments)
    |> Repo.preload(:tags)
    |> Repo.preload(:fields)
  end
end
