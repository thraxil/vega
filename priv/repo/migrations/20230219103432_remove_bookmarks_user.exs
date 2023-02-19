defmodule Vega.Repo.Migrations.RemoveBookmarksUser do
  use Ecto.Migration

  def change do
    alter table(:bookmark) do
      remove :user_id
    end
  end
end
