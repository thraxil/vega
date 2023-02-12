defmodule Vega.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:post) do
      add :body, :text, default: ""
      add :version, :integer
      add :modified, :naive_datetime
      add :node_id, references(:node), null: false
      add :user_id, references(:users), null: false
    end

    create index(:post, [:node_id])
    create index(:post, [:user_id])
  end
end
