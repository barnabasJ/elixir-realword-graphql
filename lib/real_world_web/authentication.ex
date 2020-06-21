defmodule RealWorldWeb.Authentication do
  @user_salt "xljiareodaafezx"

  def sign(data) do
    Phoenix.Token.sign(RealWorldWeb.Endpoint, @user_salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(RealWorldWeb.Endpoint, @user_salt, token, [max_age: 365 * 24 * 3600])
  end
end
