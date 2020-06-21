defmodule RealWorld.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites, primary_key: false) do
      add :article_id, references(:articles), primary_key: true
      add :user_id, references(:users, type: :uuid), primary_key: true
    end
  end
end
