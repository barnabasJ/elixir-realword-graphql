defmodule RealWorldWeb.Schema.Accounts do
  use Absinthe.Schema.Notation

  object :profile do
    field :username, :string
    field :bio, :string
    field :image, :string
    field :viewerIsFollowing, :boolean
    field :article, :article_connection do
      arg :cursor, :string
      arg :page_size, :integer, default_value: 20
      resolve &RealWorldWeb.Resolver.Content.resolve_article_for_author/3
    end
  end

  object :session do
    field :token, :string
    field :user, :profile
  end

  input_object :register_input do
    field :username, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  object :account_mutations do
    field :login, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&RealWorldWeb.Resolver.Accounts.login/3)
    end

    field :register, :profile do
      arg(:register_input, non_null(:register_input))
      resolve(&RealWorldWeb.Resolver.Accounts.register/3)
    end
  end
end
