defmodule EcommerceApiWeb.ProductsController.UpdateTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  alias EcommerceApi.Stores.Product
  alias EcommerceApi.Stores.Users.CreateSessionToken
  alias EcommerceApi.Stores.Products.Create, as: CreateProduct

  setup do
    product = build(:product)

    {:ok, %Product{} = product} = CreateProduct.call(product)

    {:ok, token} = CreateSessionToken.call(:manager, %{})

    %{product_id: product.id, token: token}
  end

  describe "update" do
    test "should update product data", %{
      conn: conn,
      token: token,
      product_id: id
    } do
      params = %{
        "session_token" => token,
        "amount" => 100
      }

      conn
      |> patch("/api/stores/products/#{id}", params)
      |> json_response(200)
    end

    test "should fail due to invalid 'price'", %{
      conn: conn,
      token: token,
      product_id: id
    } do
      params = %{
        "session_token" => token,
        "price" => -1
      }

      conn
      |> post("/api/stores/products/#{id}", params)
      |> json_response(404)
    end

    test "should fail due to empty 'session_token'", %{
      conn: conn,
      product_id: id
    } do
      params = %{
        "price" => 10
      }

      conn
      |> patch("/api/stores/products/#{id}", params)
      |> json_response(400)
    end
  end
end
