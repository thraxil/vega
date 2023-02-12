defmodule Vega.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "abraxas_tag" do
    field :name, :string
    field :slug, :string
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end
