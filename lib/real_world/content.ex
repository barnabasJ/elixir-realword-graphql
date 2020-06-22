defmodule RealWorld.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias RealWorld.Repo

  alias RealWorld.Content.Article
  alias RealWorld.Content.Tag

  def data(), do: Dataloader.Ecto.new(Repo, query: &query/2)

  def query(queryable, _), do: queryable

  def get_author_for_articles(article_ids) do
    query =
      from u in RealWorld.Accounts.User,
        join: a in Article,
        on: a.author_id == u.id,
        where: a.id in ^article_ids,
        select: {a.id, u}

    Repo.all(query)
  end

  def get_favorite_articles_for_user(user_id) do
    case Ecto.UUID.dump(user_id) do
      {:ok, uuid} ->
        Repo.all(from f in "favorites", where: f.user_id == ^uuid, select: f.article_id)

      _ ->
        :error
    end
  end

  def favorite_article(slug, user_id) do
    with %{id: id} <- get_article_by_slug(slug),
         {:ok, uuid} <- Ecto.UUID.dump(user_id),
         {1, _} <- Repo.insert_all("favorites", [%{article_id: id, user_id: uuid}]) do
      {:ok, id}
    else
      _ -> :error
    end
  end

  def get_favorite_count_for_articles(_, article_ids) do
    from(f in "favorites",
      where: f.article_id in ^Enum.uniq(article_ids),
      group_by: f.article_id,
      select: {f.article_id, count(f.article_id)}
    )
    |> Repo.all()
    |> Map.new(fn x -> x end)
  end

  def get_favorite_count_for_article(article_id) do
    Repo.one(
      from f in "favorites", where: f.article_id == ^article_id, select: count(f.article_id)
    )
  end

  def list_tags(), do: Repo.all(from t in Tag, select: t.name)

  def paginate_articles(cursor \\ nil, limit \\ 50)
  def paginate_articles(nil, limit), do: _paginate_articles(0, limit)
  def paginate_articles(cursor, limit), do: _paginate_articles(decode_term(cursor), limit)

  defp _paginate_articles(offset, limit) do
    count_query = from a in Article, select: count(a.id)

    article_query =
      Article
      |> order_by({:desc, :updated_at})
      |> limit(^limit + 1)
      |> offset(^offset)

    articles = Repo.all(article_query)
    count = Repo.one(count_query)

    article_edges =
      articles
      |> Enum.zip(offset..(offset + limit))
      |> Enum.map(fn {article, n} -> %{node: article, cursor: encode_term(n)} end)

    page_info = %{
      end_cursor: encode_term(offset + limit),
      has_next_page: offset + limit < count
    }

    %{
      edges: article_edges,
      page_info: page_info,
      total_count: count
    }
  end

  defp encode_term(term), do: term |> :erlang.term_to_binary() |> Base.encode64()
  defp decode_term(binary), do: binary |> Base.decode64!() |> :erlang.binary_to_term()

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(Article)
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id)

  def get_article_by_slug(slug) do
    q = from a in Article, where: a.slug == ^slug

    Repo.one(q)
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end
end
