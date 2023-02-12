defmodule Vega.Repo.Migrations.CreateMetaField do
  use Ecto.Migration

  def change do
    create table(:meta_field) do
      add :field_name, :string
      add :field_value, :text, default: ""
      add :node_id, references(:node), null: false
    end

    create index(:meta_field, [:node_id])
  end
end
