defmodule Vega.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :bio, :string
    field :email, :string
    field :fullname, :string
    field :username, :string

    has_many :nodes, Vega.Node
    has_many :posts, through: [:nodes, :posts]
    has_many :bookmarks, through: [:nodes, :bookmarks]
    has_many :images, through: [:nodes, :images]
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :fullname, :bio])
    |> validate_required([:username, :email, :fullname, :bio])
    |> unique_constraint(:username)
  end
end
