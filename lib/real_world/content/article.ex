defmodule RealWorld.Content.Article do
  use RealWorld.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias RealWorld.Repo

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
  end
end
