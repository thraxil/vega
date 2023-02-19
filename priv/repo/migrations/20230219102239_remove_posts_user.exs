defmodule Vega.Repo.Migrations.RemovePostsUser do
  use Ecto.Migration

  def change do
    alter table(:post) do
      remove :user_id
    end
  end
end
