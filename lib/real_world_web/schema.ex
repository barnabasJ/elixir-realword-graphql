defmodule RealWorldWeb.Schema do
  use Absinthe.Schema

  query do
    field :hello, :string do
      resolve fn _, _, _ -> {:ok, "world!"} end
    end 
  end
end
