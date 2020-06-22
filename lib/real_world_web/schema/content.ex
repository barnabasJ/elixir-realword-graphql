defmodule RealWorldWeb.Schema.Content do
  use Absinthe.Schema.Notation

  object :content_queries do
    field :articles, :article_connection do
      arg(:filter, :article_filter)
      arg(:cursor, :string)
      arg(:page_size, :integer, default_value: 20)
      resolve(&RealWorldWeb.Resolver.Content.resolve_articles/3)
    end

    field :tags, list_of(:string) do
      resolve(&RealWorldWeb.Resolver.Content.resolve_tags/3)
    end

    field :article, :article do
      arg(:slug, non_null(:string))
      resolve(&RealWorldWeb.Resolver.Content.resolve_article/3)
    end
  end

  input_object :article_filter do
    field :tag, :string
    field :author, :string
  end

  object :article do
    field :id, :id
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
    field :updated_at, :date_time

    field :tags, list_of(:string), resolve: &RealWorldWeb.Resolver.Content.resolve_tags/3

    field :viewer_has_favorited, :boolean do
      resolve(&RealWorldWeb.Resolver.Content.resolve_viewer_has_favorited/3)
    end

    field :favorites_count, :integer do
      resolve(&RealWorldWeb.Resolver.Content.resolve_favorite_count/3)
    end

    field :created_at, :date_time do
      resolve(fn parent, _, _ ->
        {:ok, Map.get(parent, :inserted_at)}
      end)
    end

    field :author, :profile do
      resolve(&RealWorldWeb.Resolver.Content.resolve_author/3)
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

  object :content_mutations do
    field :favorite_article, :id do
      middleware(RealWorldWeb.Middleware.Authorize)
      arg(:slug, :string)
      resolve(&RealWorldWeb.Resolver.Content.resolve_favorite_article/3)
    end
  end
end
