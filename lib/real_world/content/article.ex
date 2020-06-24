defmodule RealWorld.Content.Article do
  use RealWorld.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "articles" do
    field :body, :string
    field :description, :string
    field :slug, :string
    field :title, :string
    many_to_many :tags, RealWorld.Content.Tag, join_through: "article_tags"
    belongs_to :author, RealWorld.Accounts.User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    IO.inspect(attrs: attrs)

    article
    |> cast(attrs, [:slug, :title, :description, :body, :author_id])
    |> validate_required([:slug, :title, :description, :body, :author_id])
    |> put_assoc(:tags, parse_tags(attrs))
    |> unique_constraint([:slug], name: :articles_slug_index)
  end

  defp parse_tags(attrs) do
    IO.inspect(attrs)

    (attrs[:tags] || [])
    |> IO.inspect()
    |> Enum.map(&String.trim/1)
    |> IO.inspect()
    |> Enum.reject(&(&1 == ""))
    |> IO.inspect()
    |> insert_and_get_all()
  end

  defp now(), do: DateTime.utc_now() |> DateTime.truncate(:second)

  def insert_and_get_all([]) do
    []
  end

  def insert_and_get_all(names) do
    maps =
      Enum.map(
        names,
        &%{name: &1, inserted_at: now(), updated_at: now()}
      )

    RealWorld.Repo.insert_all(RealWorld.Content.Tag, maps, on_conflict: :nothing)
    RealWorld.Repo.all(from t in RealWorld.Content.Tag, where: t.name in ^names)
  end
end
