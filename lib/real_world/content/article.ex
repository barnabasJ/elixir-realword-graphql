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
    article
    |> cast(attrs, [:slug, :title, :description, :body, :author_id])
    |> validate_required([:slug, :title, :description, :body, :author_id])
    |> put_assoc(:tags, parse_tags(attrs))
  end

  defp parse_tags(attrs) do
    (attrs["tags"] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> insert_and_get_all()
  end

  defp insert_and_get_all([]) do
    []
  end

  defp insert_and_get_all(names) do
    maps = Enum.map(names, &%{name: &1})

    RealWorld.Repo.insert_all(RealWorld.Content.Tag, maps, on_conflict: :nothing)
    RealWorld.Repo.all(from t in RealWorld.Content.Tag, where: t.name in ^names)
  end
end
