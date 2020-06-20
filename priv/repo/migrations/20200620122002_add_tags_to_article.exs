defmodule RealWorld.Repo.Migrations.AddTagsToArticle do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      timestamps()
    end

    create unique_index(:tags, [:name])

    create table(:article_tags, primary_key: false) do
      add :article_id, references(:articles)
      add :tag_id, references(:tags)
    end
  end
end
