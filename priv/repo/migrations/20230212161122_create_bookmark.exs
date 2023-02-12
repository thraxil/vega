defmodule Vega.Repo.Migrations.CreateBookmark do
  use Ecto.Migration

  def change do
    create table(:bookmark) do
      add :description, :text, default: ""
      add :url, :string
      add :via_name, :string
      add :via_url, :string
      add :version, :integer
      add :modified, :naive_datetime
      add :node_id, references(:node), null: false
      add :user_id, references(:users), null: false
    end

    create index(:bookmark, [:node_id])
    create index(:bookmark, [:user_id])
  end
end
