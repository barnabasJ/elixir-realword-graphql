defmodule RealWorldWeb.Schema.Accounts do
  use Absinthe.Schema.Notation

  object :profile do
    field :username, :string
    field :bio, :string
    field :image, :string
    field :viewerIsFollowing, :boolean
  end
end
