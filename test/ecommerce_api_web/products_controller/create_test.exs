defmodule EcommerceApiWeb.ProductsController.CreateTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  alias EcommerceApi.Stores.Users.CreateSessionToken
  alias Test.JSONParse

  @url "/api/stores/products"

  setup do
    {:ok, token} = CreateSessionToken.call(:manager, %{})

    %{token: token}
  end

  describe "create" do
    test "should return product data", %{conn: conn, token: token} do
      payload =
        build(:product)
        |> Map.put(:session_token, token)
        |> JSONParse.call()

      conn
      |> post(@url, payload)
      |> json_response(201)
    end

    test "should fail due to empty session_token", %{conn: conn} do
      payload =
        build(:product)
        |> JSONParse.call()

      conn
      |> post(@url, payload)
      |> json_response(400)
    end
  end
end
