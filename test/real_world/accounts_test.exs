defmodule RealWorld.AccountsTest do
  use RealWorld.DataCase

  alias RealWorld.Accounts

  describe "users" do
    alias RealWorld.Accounts.User

    @valid_attrs %{bio: "some bio", image: "some image", name: "some name"}
    @update_attrs %{
      bio: "some updated bio",
      image: "some updated image",
      name: "some updated name"
    }
    @invalid_attrs %{bio: nil, image: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.bio == "some bio"
      assert user.image == "some image"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.bio == "some updated bio"
      assert user.image == "some updated image"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "logins" do
    alias RealWorld.Accounts.Login

    @valid_attrs %{email: "some email", password: "some password"}
    @update_attrs %{email: "some updated email", password: "some updated password"}
    @invalid_attrs %{email: nil, password: nil}

    def login_fixture(attrs \\ %{}) do
      {:ok, login} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_login()

      login
    end

    test "list_logins/0 returns all logins" do
      login = login_fixture()
      assert Accounts.list_logins() == [login]
    end

    test "get_login!/1 returns the login with given id" do
      login = login_fixture()
      assert Accounts.get_login!(login.id) == login
    end

    test "create_login/1 with valid data creates a login" do
      assert {:ok, %Login{} = login} = Accounts.create_login(@valid_attrs)
      assert login.email == "some email"
      assert login.password == "some password"
    end

    test "create_login/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_login(@invalid_attrs)
    end

    test "update_login/2 with valid data updates the login" do
      login = login_fixture()
      assert {:ok, %Login{} = login} = Accounts.update_login(login, @update_attrs)
      assert login.email == "some updated email"
      assert login.password == "some updated password"
    end

    test "update_login/2 with invalid data returns error changeset" do
      login = login_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_login(login, @invalid_attrs)
      assert login == Accounts.get_login!(login.id)
    end

    test "delete_login/1 deletes the login" do
      login = login_fixture()
      assert {:ok, %Login{}} = Accounts.delete_login(login)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_login!(login.id) end
    end

    test "change_login/1 returns a login changeset" do
      login = login_fixture()
      assert %Ecto.Changeset{} = Accounts.change_login(login)
    end
  end
end
