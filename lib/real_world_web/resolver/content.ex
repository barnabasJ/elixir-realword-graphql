defmodule RealWorldWeb.Resolver.Content do
  import Absinthe.Resolution.Helpers, only: [batch: 3]

  def resolve_articles(_, %{cursor: cursor}, _) do
    {:ok, RealWorld.Content.paginate_articles(cursor)}
  end

  def resolve_articles(_, _, _) do
    {:ok, RealWorld.Content.paginate_articles()}
  end

  def resolve_article(_, %{slug: slug}, _) do
    {:ok, RealWorld.Content.get_article_by_slug(slug)}
  end

  def resolve_favorite_count(%{id: id}, _, _) do
    batch({RealWorld.Content, :get_favorite_count_for_articles}, id,
      fn favCounts -> 
        {:ok, Map.get(favCounts, id, 0)} end)
  end

  def resolve_tags(_, _, _) do
    {:ok, RealWorld.Content.list_tags()}
  end

  def resolve_favorite_article(_, %{slug: slug}, %{
        context: %{current_user: %RealWorld.Accounts.User{id: id}}
      }) do
    case RealWorld.Content.favorite_article(slug, id) do
      {:ok, id} -> {:ok, id}
      _ -> {:error, "unable to save favorite"}
    end
  end
end
