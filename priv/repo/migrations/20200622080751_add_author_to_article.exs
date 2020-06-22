defmodule RealWorld.Repo.Migrations.AddAuthorToArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :author_id, references(:users, type: :uuid)
    end
  end
end
