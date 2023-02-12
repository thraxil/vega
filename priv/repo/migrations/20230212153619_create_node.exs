defmodule Vega.Repo.Migrations.CreateNode do
  use Ecto.Migration

  def change do
    create table(:node) do
      add :slug, :string, null: false
      add :title, :string, null: false
      add :status, :string, null: false, size: 7
      add :type, :string, null: false, size: 8
      add :comments_allowed, :boolean, default: false, null: false
      add :created, :naive_datetime
      add :modified, :naive_datetime
      add :user_id, references(:users), null: false
    end

    create index(:node, [:user_id])
  end
end
