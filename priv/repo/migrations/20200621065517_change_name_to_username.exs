defmodule RealWorld.Repo.Migrations.ChangeNameToUsername do
  use Ecto.Migration

  def change do
    rename table(:users), :name, to: :username
  end
end
