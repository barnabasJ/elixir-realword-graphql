defmodule RealWorldWeb.Schema do
  use Absinthe.Schema

  import_types __MODULE__.Content

  object :page_info do
    field :end_cursor, :string
    field :has_next_page, :boolean
  end

  object :profile do
    field :username, :string
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
