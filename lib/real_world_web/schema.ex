defmodule RealWorldWeb.Schema do
  use Absinthe.Schema

  object :article do
    field :id, :id
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
    field :tags, list_of(:string)
    field :updated_at, :date_time
    field :viewer_has_favorited, :integer
    field :favorites_count, :integer

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

  object :page_info do
    field :end_cursor, :string
    field :has_next_page, :boolean
  end

  object :article_connection do
    field :edges, list_of(:article_edge)
    field :page_info, :page_info
    field :total_count, :integer
  end

  object :profile do
    field :name, :string
    field :bio, :string
    field :image, :string
    field :viewerIsFollowing, :boolean
  end

  query do
    field :articles, :article_connection do
      arg(:cursor, :string)
      resolve(&RealWorldWeb.Resolver.Content.resolve_articles/3)
    end

    field :article, :article do
      arg(:slug, non_null(:string))
      resolve(&RealWorldWeb.Resolver.Content.resolve_article/3)
    end

    field :profile, :profile do
      arg(:username, :string)
      resolve(&RealWorldWeb.Resolver.Accounts.resolve_profile/3)
    end

    field :tags, list_of(:string) do
      resolve(&RealWorldWeb.Resolver.Content.resolve_tags/3)
    end
  end

  scalar :date_time do
    parse(fn input ->
      case DateTime.from_iso8601(input.value) do
        {:ok, date_time} -> {:ok, date_time}
        _ -> :error
      end
    end)

    serialize(fn date_time ->
      DateTime.to_iso8601(date_time)
    end)
  end
end
