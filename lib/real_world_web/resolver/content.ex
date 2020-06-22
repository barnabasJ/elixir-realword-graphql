defmodule RealWorldWeb.Resolver.Content do
  import Absinthe.Resolution.Helpers, only: [batch: 3, on_load: 2]



  def resolve_articles(_, %{cursor: cursor, page_size: page_size, filter: filter}, _),
    do: {:ok, RealWorld.Content.paginate_articles(cursor, page_size, filter)}

  def resolve_articles(_, %{cursor: cursor, page_size: page_size}, _),
    do: {:ok, RealWorld.Content.paginate_articles(cursor, page_size, nil)}

  def resolve_articles(_, %{page_size: page_size, filter: filter}, _),
    do: {:ok, RealWorld.Content.paginate_articles(nil, page_size, filter)}

  def resolve_articles(_, %{page_size: page_size}, _),
    do: {:ok, RealWorld.Content.paginate_articles(nil, page_size, nil)}

  def resolve_article(_, %{slug: slug}, _) do
    {:ok, RealWorld.Content.get_article_by_slug(slug)}
  end

  def resolve_tags(article, _, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(RealWorld.Content, :tags, article)
    |> on_load(fn loader ->
      tags =
        loader
        |> Dataloader.get(RealWorld.Content, :tags, article)
        |> Enum.map(& &1.name)

      {:ok, tags}
    end)
  end

  def resolve_tags(_, _, _) do
    {:ok, RealWorld.Content.list_tags()}
  end

  def resolve_author(%{id: article_id}, _, _) do
    batch({__MODULE__, :get_author_for_articles}, article_id, fn authors ->
      {:ok, Map.get(authors, article_id, nil)}
    end)
  end

  def get_author_for_articles(_, article_ids) do
    article_ids
    |> RealWorld.Content.get_author_for_articles()
    |> Enum.reduce(%{}, fn {article_id, author}, acc -> Map.put(acc, article_id, author) end)
  end

  def resolve_favorite_count(%{id: id}, _, _) do
    batch({RealWorld.Content, :get_favorite_count_for_articles}, id, fn favCounts ->
      {:ok, Map.get(favCounts, id, 0)}
    end)
  end

  def resolve_viewer_has_favorited(%{id: article_id}, _, %{
        context: %{current_user: %RealWorld.Accounts.User{id: user_id}}
      }) do
    batch(
      {RealWorldWeb.Resolver.Content, :get_views_for_article},
      user_id,
      fn favs ->
        {:ok, Map.get(favs, article_id, false)}
      end
    )
  end

  def resolve_viewer_has_favorited(_, _, _), do: {:ok, nil}

  def get_views_for_article(_, [user_id | _]) do
    RealWorld.Content.get_favorite_articles_for_user(user_id)
    |> Enum.reduce(%{}, fn article_id, acc -> Map.put(acc, article_id, true) end)
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
