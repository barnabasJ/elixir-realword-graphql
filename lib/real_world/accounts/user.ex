defmodule RealWorld.Accounts.User do
  use RealWorld.Schema
  import Ecto.Changeset
  alias RealWorld.Accounts

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :bio, :string
    field :image, :string
    field :username, :string
    has_one :login, Accounts.Login

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :bio, :image])
    |> validate_required([:username])
  end
end
