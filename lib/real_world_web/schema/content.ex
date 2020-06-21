defmodule RealWorldWeb.Schema.Content do
  use Absinthe.Schema.Notation

  object :article do
    field :id, :id
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
    field :tags, list_of(:string)
    field :updated_at, :date_time
    field :viewer_has_favorited, :integer
    field :favorites_count, :integer do
      resolve &RealWorldWeb.Resolver.Content.resolve_favorite_count/3
    end

    field :created_at, :date_time do
      resolve(fn parent, _, _ ->
        {:ok, Map.get(parent, :inserted_at)}
      end)
    end
  end

  object :article_edge do
    field :node, :article
    field :cursor, :string
  end

  object :article_connection do
    field :edges, list_of(:article_edge)
    field :page_info, :page_info
    field :total_count, :integer
  end
end
