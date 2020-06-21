defmodule RealWorld.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias RealWorld.Repo

  alias RealWorld.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def get_user_by_username(username) do
    q = from u in User, where: u.username == ^username
    Repo.one(q)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias RealWorld.Accounts.Login
  alias Comeonin.Ecto.Password

  @doc """
  Returns the list of logins.

  ## Examples

      iex> list_logins()
      [%Login{}, ...]

  """
  def list_logins do
    Repo.all(Login)
  end

  @doc """
  Gets a single login.

  Raises `Ecto.NoResultsError` if the Login does not exist.

  ## Examples

      iex> get_login!(123)
      %Login{}

      iex> get_login!(456)
      ** (Ecto.NoResultsError)

  """
  def get_login!(id), do: Repo.get!(Login, id)

  @doc """
  Creates a login.

  ## Examples

      iex> create_login(%{field: value})
      {:ok, %Login{}}

      iex> create_login(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_login(attrs \\ %{}) do
    %Login{}
    |> Login.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a login.

  ## Examples

      iex> update_login(login, %{field: new_value})
      {:ok, %Login{}}

      iex> update_login(login, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_login(%Login{} = login, attrs) do
    login
    |> Login.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a login.

  ## Examples

      iex> delete_login(login)
      {:ok, %Login{}}

      iex> delete_login(login)
      {:error, %Ecto.Changeset{}}

  """
  def delete_login(%Login{} = login) do
    Repo.delete(login)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking login changes.

  ## Examples

      iex> change_login(login)
      %Ecto.Changeset{data: %Login{}}

  """
  def change_login(%Login{} = login, attrs \\ %{}) do
    Login.changeset(login, attrs)
  end

  def authenticate(email, password) do
    login = Repo.get_by(Login, email: email)

    with %{password: digest} <- login,
         true <- Password.valid?(password, digest) do
      {:ok, login}
    else
      _ -> :error
    end
  end
end
