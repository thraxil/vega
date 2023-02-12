defmodule Vega.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post" do
    field :body, :string
    field :modified, :naive_datetime
    field :version, :integer

    belongs_to :user, Vega.User
    belongs_to :node, Vega.Node
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :version, :modified])
    |> validate_required([:body, :version, :modified])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:node_id)
  end
end
