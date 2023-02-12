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
    has_many :posts, Vega.Post
    has_many :bookmarks, Vega.Bookmark
    has_many :images, Vega.Image
    has_many :comments, Vega.Comment
    has_many :fields, Vega.MetaField

    many_to_many :tags, Vega.Tag, join_through: Vega.NodeTag
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:slug, :title, :status, :type, :comments_allowed, :created, :modified])
    |> validate_required([:slug, :title, :status, :type, :comments_allowed, :created, :modified])
    |> foreign_key_constraint(:user_id)
  end
end
