defmodule Vega.Site do
  @moduledoc """
  The Site context.
  """

  import Ecto.Changeset, only: [change: 2]
  import Ecto.Query, warn: false
  alias Vega.Repo

  alias Vega.User
  alias Vega.Node
  alias Vega.Post
  alias Vega.Image
  alias Vega.Bookmark
  alias Vega.Tag

  def get_user!(username) do
    Repo.get_by(User, username: username)
  end

  def list_users() do
    Repo.all(from u in User, order_by: [asc: u.fullname])
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

  defp _get_node_c!(node, c) do
    q =
      from p in c,
        where: p.node_id == ^node.id,
        order_by: [desc: :version],
        limit: 1

    Repo.one!(q)
  end

  def get_node_content!(node = %Node{:type => "post"}) do
    _get_node_c!(node, Post)
  end

  def get_node_content!(node = %Node{:type => "image"}) do
    _get_node_c!(node, Image)
  end

  def get_node_content!(node = %Node{:type => "bookmark"}) do
    _get_node_c!(node, Bookmark)
  end

  def get_tag!(slug) do
    Repo.one!(
      from tag in Tag,
        where: tag.slug == ^slug,
        left_join: nodes in assoc(tag, :nodes),
        left_join: user in assoc(nodes, :user),
        preload: [nodes: {nodes, user: user}]
    )
  end

  def list_tags() do
    Repo.all(from t in Tag, order_by: [asc: t.name])
  end
end
