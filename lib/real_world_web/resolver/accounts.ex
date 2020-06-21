defmodule RealWorldWeb.Resolver.Accounts do
  def resolve_profile(_, %{username: username}, _) do
    {:ok, RealWorld.Accounts.get_user_by_username(username)}
  end

  def login(_, %{email: email, password: password}, _) do
    case RealWorld.Accounts.authenticate(email, password) do
      {:ok, login} -> 
        token = RealWorldWeb.Authentication.sign(%{
          id: login.user_id
        })
        {:ok, %{token: token, user: login.user}}
      _ ->
        {:error, "incorrect email or password"}
    end 
  end

  def register(_, %{register_input: %{username: username, email: email, password: password}}, _) do
    RealWorld.Accounts.create_user(%{
      username: username,
      login: %{
        email: email,
        password: password
      }
    })
  end
end
