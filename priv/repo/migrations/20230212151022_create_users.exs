defmodule Vega.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, size: 128, null: false
      add :email, :string
      add :fullname, :string
      add :bio, :text, default: ""
    end

    create unique_index(:users, [:username])
  end
end
