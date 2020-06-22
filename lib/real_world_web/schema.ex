defmodule RealWorldWeb.Schema do
  use Absinthe.Schema

  import_types(__MODULE__.Content)
  import_types(__MODULE__.Accounts)

  def middleware(middleware, field, object) do
    middleware
    |> apply(:auth, field, object)
    |> apply(:errors, field, object)
    |> apply(:debug, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [RealWorldWeb.Middleware.ChangesetErrors]
  end

  defp apply(middleware, :auth, %{identifier: :me}, _object) do
    middleware ++ [RealWorldWeb.Middleware.Authorize]
  end

  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{RealWorldWeb.Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end

  defp apply(middleware, _, _, _), do: middleware

  object :page_info do
    field :end_cursor, :string
    field :has_next_page, :boolean
  end

  object :me do
    field :profile, :profile do
      resolve(&RealWorldWeb.Resolver.Accounts.resolve_profile/3)
    end
  end

  query do
    field :me, :me do
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end

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

  mutation do
    import_fields(:account_mutations)
    import_fields(:content_mutations)
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
