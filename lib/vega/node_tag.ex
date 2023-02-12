defmodule Vega.NodeTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "node_tags" do
    belongs_to :node, Vega.Node
    belongs_to :tag, Vega.Tag
  end

  @doc false
  def changeset(node_tag, attrs) do
    node_tag
    |> cast(attrs, [])
    |> validate_required([])
    |> foreign_key_constraint(:tag_id)
    |> foreign_key_constraint(:node_id)
  end
end
