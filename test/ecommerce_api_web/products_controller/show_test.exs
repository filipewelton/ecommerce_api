defmodule EcommerceApiWeb.ProductsController.ShowTest do
  use EcommerceApiWeb.ConnCase

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

  describe "show" do
    test "should return product data", %{conn: conn, product_id: id, token: token} do
      url = "/api/stores/products/#{id}?session_token=#{token}"

      conn
      |> get(url)
      |> json_response(200)
    end

    test "should fail due to id not found", %{conn: conn, token: token} do
      id = Faker.UUID.v4()
      url = "/api/stores/products/#{id}?session_token=#{token}"

      conn
      |> get(url)
      |> json_response(404)
    end

    test "should fail due to invalid id", %{conn: conn, token: token} do
      id = nil
      url = "/api/stores/products/#{id}?session_token=#{token}"

      conn
      |> get(url)
      |> json_response(404)
    end

    test "should fail due to empty 'session_token'", %{conn: conn, product_id: id} do
      url = "/api/stores/products/#{id}"

      conn
      |> get(url)
      |> json_response(400)
    end
  end
end
