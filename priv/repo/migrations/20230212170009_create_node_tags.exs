defmodule Vega.Repo.Migrations.CreateNodeTags do
  use Ecto.Migration

  def change do
    create table(:node_tags) do
      add :node_id, references(:node), null: false
      add :tag_id, references(:abraxas_tag), null: false
    end

    create index(:node_tags, [:node_id])
    create index(:node_tags, [:tag_id])
  end
end
