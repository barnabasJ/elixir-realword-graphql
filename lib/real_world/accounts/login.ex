defmodule RealWorld.Accounts.Login do
  use RealWorld.Schema
  import Ecto.Changeset
  alias RealWorld.Accounts

  schema "logins" do
    field :email, :string
    field :password, Comeonin.Ecto.Password
    belongs_to(:user, Accounts.User, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(login, attrs) do
    login
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
