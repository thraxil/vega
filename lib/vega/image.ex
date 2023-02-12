defmodule Vega.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "image" do
    field :description, :string
    field :ext, :string
    field :height, :integer
    field :modified, :naive_datetime
    field :rhash, :string
    field :thumb_height, :integer
    field :thumb_width, :integer
    field :version, :integer
    field :width, :integer

    belongs_to :user, Vega.User
    belongs_to :node, Vega.Node
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:description, :thumb_width, :thumb_height, :width, :height, :ext, :rhash, :version, :modified])
    |> validate_required([:description, :thumb_width, :thumb_height, :width, :height, :ext, :rhash, :version, :modified])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:node_id)
  end
end
