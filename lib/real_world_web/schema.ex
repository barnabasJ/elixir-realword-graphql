defmodule RealWorldWeb.Schema do
  use Absinthe.Schema

  object :article do
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
  end

  object :article_edge do
    field :node, :article
    field :cursor, :string
  end

  object :page_info do
    field :end_cursor, :string
    field :has_next_page, :boolean
  end

  object :article_connection do
    field :edges, list_of(:article_edge)
    field :page_info, :page_info
    field :total_count, :integer
  end

  query do
    field :articles, :article_connection do
      arg :cursor, :string
      resolve(&RealWorldWeb.Resolver.Content.resolve_articles/3)
    end
  end
end
