defmodule Vega.Repo.Migrations.PostBodyHtml do
  use Ecto.Migration

  def change do
    alter table(:post) do
      add :body_html, :text, default: ""
    end
  end
end
