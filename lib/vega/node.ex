defmodule Vega.Node do
  use Ecto.Schema
  import Ecto.Changeset

  schema "node" do
    field :comments_allowed, :boolean, default: false
    field :created, :naive_datetime
    field :modified, :naive_datetime
    field :slug, :string
    field :status, :string
    field :title, :string
    field :type, :string

    belongs_to :user, Vega.User
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:slug, :title, :status, :type, :comments_allowed, :created, :modified])
    |> validate_required([:slug, :title, :status, :type, :comments_allowed, :created, :modified])
    |> foreign_key_constraint(:user_id)
  end
end
