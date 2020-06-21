defmodule RealWorldWeb.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  def call(%{context: %{current_user: %RealWorld.Accounts.User{} = _user}} = resolution, _) do
    resolution
  end

  def call(resolution, _) do
    resolution
    |> Absinthe.Resolution.put_result({:error, "unauthorized"})
  end
end
