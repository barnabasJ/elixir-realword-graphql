defmodule RealWorldWeb.Schema.Accounts do
  use Absinthe.Schema.Notation

  object :profile do
    field :username, :string
    field :bio, :string
    field :image, :string
    field :viewerIsFollowing, :boolean
  end

  object :account_mutations do
    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &RealWorldWeb.Resolver.Accounts.login/3
    end
  end
end
