defmodule Vega.MetaField do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meta_field" do
    field :field_name, :string
    field :field_value, :string

    belongs_to :node, Vega.Node
  end

  @doc false
  def changeset(meta_field, attrs) do
    meta_field
    |> cast(attrs, [:field_name, :field_value])
    |> validate_required([:field_name, :field_value])
    |> foreign_key_constraint(:node_id)
    |> validate_length(:field_name, max: 255)
    |> unique_constraint([:field_name, :node])
  end
end
