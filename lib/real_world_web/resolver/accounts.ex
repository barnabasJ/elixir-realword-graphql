defmodule RealWorldWeb.Resolver.Accounts do
  def resolve_profile(_, %{username: username}, _) do
    {:ok, RealWorld.Accounts.get_user_by_username(username)}
  end
end
