defmodule Vega.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment" do
    field :author_email, :string
    field :author_name, :string
    field :author_url, :string
    field :body, :string
    field :created, :naive_datetime
    field :reply_to, :integer
    field :status, :string

    belongs_to :node, Vega.Node
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :reply_to, :created, :status, :author_email, :author_name, :author_url])
    |> validate_required([
      :body,
      :reply_to,
      :created,
      :status,
      :author_email,
      :author_name,
      :author_url
    ])
    |> foreign_key_constraint(:node_id)
  end
end
