defmodule RealWorldWeb.Middleware.Debug do
  @behaviour Absinthe.Middleware

  def call(res, :start) do
    path = res |> Absinthe.Resolution.path() |> Enum.join(".")

    IO.puts("""
    ===========================
    starting: #{path}
    with source: #{inspect(res.source)}|
    """)

    %{res | middleware: res.middleware ++ [{__MODULE__, {:finish, path}}]}
  end

  def call(res, {:finish, path}) do
    IO.puts("""
    completed: #{path}
    value: #{inspect(res.value)}
    ===========================
    """)

    res
  end
end
