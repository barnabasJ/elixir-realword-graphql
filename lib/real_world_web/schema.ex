defmodule RealWorldWeb.Schema do
  use Absinthe.Schema

  object :article do
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
  end

  query do
    field :articles, list_of(:article) do
      resolve fn _, _, _ -> {:ok, []} end
    end
  end
end
