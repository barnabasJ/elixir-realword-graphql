defmodule RealWorldWeb.Schema do
  use Absinthe.Schema

  import_types(__MODULE__.Content)
  import_types(__MODULE__.Accounts)

  def dataloader() do
    Dataloader.new()
    |> Dataloader.add_source(RealWorld.Content, RealWorld.Content.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

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

  query do
    import_fields(:content_queries)

    field :me, :me do
      middleware(RealWorldWeb.Middleware.Authorize)
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end

    field :profile, :profile do
      arg(:username, :string)
      resolve(&RealWorldWeb.Resolver.Accounts.resolve_profile/3)
    end
  end

  mutation do
    field :content, :content_mutations do
      middleware(RealWorldWeb.Middleware.Authorize)
      resolve(fn _, _, _ -> {:ok, %{}} end)
    end

    import_fields(:account_mutations)
  end

  object :page_info do
    field :end_cursor, :string
    field :has_next_page, :boolean
  end

  object :me do
    field :profile, :profile do
      resolve(&RealWorldWeb.Resolver.Accounts.resolve_profile/3)
    end
  end

  subscription do
    import_fields(:content_subscriptions)
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
