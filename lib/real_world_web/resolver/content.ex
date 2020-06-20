defmodule RealWorldWeb.Resolver.Content do
  def resolve_articles(_, _, _) do
    {:ok, RealWorld.Content.list_articles()}
  end
end
