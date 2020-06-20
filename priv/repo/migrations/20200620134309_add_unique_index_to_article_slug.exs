defmodule RealWorld.Repo.Migrations.AddUniqueIndexToArticleSlug do
  use Ecto.Migration

  def change do
    create unique_index(:articles, [:slug])
  end
end
