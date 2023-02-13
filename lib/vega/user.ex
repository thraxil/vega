defmodule Vega.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :bio, :string
    field :email, :string
    field :fullname, :string
    field :username, :string

    has_many :nodes, Vega.Node
    has_many :posts, Vega.Post
    has_many :bookmarks, Vega.Bookmark
    has_many :images, Vega.Image
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :fullname, :bio])
    |> validate_required([:username, :email, :fullname, :bio])
    |> unique_constraint(:username)
  end
end
