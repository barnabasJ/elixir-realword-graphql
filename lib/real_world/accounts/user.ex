defmodule RealWorld.Accounts.User do
  use RealWorld.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :bio, :string
    field :image, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :bio, :image])
    |> validate_required([:name])
  end
end
