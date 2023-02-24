defmodule Vega.Node do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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

    many_to_many :tags, Vega.Tag, join_through: Vega.NodeTag, on_replace: :delete
  end

  @doc false
  def changeset(node, attrs \\ %{}) do
    node
    |> cast(attrs, [:slug, :title, :status, :type, :comments_allowed, :created, :modified])
    |> validate_required([:slug, :title, :status, :type, :comments_allowed, :created, :modified])
    |> foreign_key_constraint(:user_id)
    |> validate_length(:status, max: 7)
    |> validate_length(:type, max: 8)
    |> validate_length(:title, max: 255)
    |> validate_length(:slug, max: 255)
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  def parse_tags(tags) do
    tags
    |> String.split(" ")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.uniq()
    |> Enum.map(fn s ->
      %{
        :name => String.downcase(s),
        :slug => slugify(String.downcase(s))
      }
    end)
  end

  def by_user(query \\ Vega.Node, user) do
    where(query, [n], n.user_id == ^user.id)
  end

  def by_type(query \\ Vega.Node, type) do
    where(query, [n], n.type == ^type)
  end

  def published(query \\ Vega.Node) do
    where(query, [n], n.status == "Publish")
  end

  def by_year(query \\ Vega.Node, year) do
    where(query, [n], fragment("date_part('YEAR', ?)", n.created) == ^year)
  end

  def by_month(query \\ Vega.Node, month) do
    where(query, [n], fragment("date_part('MONTH', ?)", n.created) == ^month)
  end

  def by_day(query \\ Vega.Node, day) do
    where(query, [n], fragment("date_part('DAY', ?)", n.created) == ^day)
  end

  def by_slug(query \\ Vega.Node, slug) do
    where(query, [n], n.slug == ^slug)
  end

  def by_date(query \\ Vega.Node, created) do
    where(query, [n], fragment("?::date", n.created) == ^created)
  end
end
