defmodule RealWorld.Repo.Migrations.CreateLogins do
  use Ecto.Migration

  def change do
    create table(:logins) do
      add :email, :string
      add :password, :string
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:logins, [:user_id])
    create index(:logins, [:email])
    create unique_index(:logins, [:email, :user_id])
  end
end
