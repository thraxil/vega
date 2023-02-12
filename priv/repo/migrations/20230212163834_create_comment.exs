defmodule Vega.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comment) do
      add :body, :text, default: ""
      add :reply_to, :integer
      add :created, :naive_datetime
      add :status, :string, size: 30
      add :author_email, :string
      add :author_name, :string
      add :author_url, :string
      add :node_id, references(:node), null: false
    end

    create index(:comment, [:node_id])
  end
end
