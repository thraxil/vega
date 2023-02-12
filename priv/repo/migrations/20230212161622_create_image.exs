defmodule Vega.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:image) do
      add :description, :text, default: ""
      add :thumb_width, :integer
      add :thumb_height, :integer
      add :width, :integer
      add :height, :integer
      add :ext, :string, size: 3
      add :rhash, :string
      add :version, :integer
      add :modified, :naive_datetime
      add :node_id, references(:node), null: false
      add :user_id, references(:users), null: false
    end

    create index(:image, [:node_id])
    create index(:image, [:user_id])
  end
end
