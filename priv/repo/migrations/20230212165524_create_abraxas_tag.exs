defmodule Vega.Repo.Migrations.CreateAbraxasTag do
  use Ecto.Migration

  def change do
    create table(:abraxas_tag) do
      add :name, :string, null: false
      add :slug, :string, null: false
    end
  end
end
