defmodule RealWorldWeb.ArticleTest do
  use RealWorldWeb.ConnCase, async: true

  @query """
  query Article($slug: String!) {
    article(slug: $slug) {
      title
      author {
        username
        bio
        image
      }
      tags
      favoritesCount
    }
  }
  """

  @variables %{slug: "asynchronous"}

  test "menuItems field returns menu items", %{conn: conn} do
    conn = get conn, "/api", query: @query, variables: @variables

    assert %{
             "data" => %{
               "article" => %{
                 "author" => _author,
                 "favoritesCount" => 0,
                  "tags" => ["didactic", "stable"],
                  "title" => "Rockin' in the Rockies"
               }
             }
           } = json_response(conn, 200)
  end
end
