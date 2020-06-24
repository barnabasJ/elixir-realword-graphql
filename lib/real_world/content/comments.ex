defmodule RealWorld.Content.Comment do
  use RealWorld.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :article, RealWorld.Content.Article
    belongs_to :author, RealWorld.Accounts.User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(comments, attrs) do
    comments
    |> cast(attrs, [:article_id, :body, :author_id])
    |> validate_required([:article_id, :body, :author_id])
  end
end
