defmodule RealWorld.Content.Article do
  use RealWorld.Schema
  import Ecto.Changeset

  schema "articles" do
    field :body, :string
    field :description, :string
    field :slug, :string
    field :title, :string
    many_to_many :tags, RealWorld.Content.Tag, join_through: "article_tags"

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:slug, :title, :description, :body])
    |> validate_required([:slug, :title, :description, :body])
  end
end
