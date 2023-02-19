defmodule Vega.Repo.Migrations.RemoveImageUser do
  use Ecto.Migration

  def change do
    alter table(:image) do
      remove :user_id
    end
  end
end
