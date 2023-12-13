defmodule EcommerceApiWeb.OrdersController.CreateTest do
  use EcommerceApiWeb.ConnCase, async: true

  alias Test.{Generators, Factory}
  alias EcommerceApi.Customers.CreateSessionToken

  @url "/api/stores/orders"

  setup do
    customer = Generators.build(:customer)

    {:ok, token} = CreateSessionToken.call(:customer, %{})

    %{customer_id: customer.id, token: token}
  end

  describe "create" do
    test "should return status code 200", %{
      conn: conn,
      customer_id: cid,
      token: token
    } do
      product = Generators.build(:product)

      payload =
        Factory.build(:order, customer_id: cid, session_token: token)
        |> Map.put("items_id", [product.id])

      conn
      |> post(@url, payload)
      |> json_response(201)
    end
  end
end
