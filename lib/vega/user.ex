defmodule Vega.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :bio, :string
    field :email, :string
    field :fullname, :string
    field :username, :string
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :fullname, :bio])
    |> validate_required([:username, :email, :fullname, :bio])
  end
end
