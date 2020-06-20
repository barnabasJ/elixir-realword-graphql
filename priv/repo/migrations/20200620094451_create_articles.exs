defmodule RealWorld.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :slug, :string
      add :title, :string
      add :description, :text
      add :body, :text

      timestamps()
    end
  end
end
