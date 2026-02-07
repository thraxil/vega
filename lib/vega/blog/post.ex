defmodule Vega.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post" do
    field :body, :string
    field :body_html, :string
    field :modified, :naive_datetime
    field :version, :integer

    belongs_to :node, Vega.Node
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :version, :modified])
    |> validate_required([:body, :version, :modified])
    |> foreign_key_constraint(:node_id)
    |> gen_body_html
  end

  defp gen_body_html(%{valid?: true, changes: %{body: body}} = changeset) do
    put_change(changeset, :body_html, Earmark.as_html!(body))
  end

  defp gen_body_html(changeset), do: changeset
end
