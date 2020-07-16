defmodule RealWorld.ExampleTest do
  use ExUnit.Case, async: true

  def add(x, y), do: x + y

  test "unit test a function" do
    assert add(1, 2) == 3
  end
end
