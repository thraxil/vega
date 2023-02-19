defmodule Vega.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookmark" do
    field :description, :string
    field :modified, :naive_datetime
    field :url, :string
    field :version, :integer
    field :via_name, :string
    field :via_url, :string

    belongs_to :node, Vega.Node
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [:description, :url, :via_name, :via_url, :version, :modified])
    |> validate_required([:description, :url, :via_name, :via_url, :version, :modified])
    |> foreign_key_constraint(:node_id)
    |> validate_length(:url, max: 255)
    |> validate_length(:via_name, max: 255)
    |> validate_length(:via_url, max: 255)
  end
end
