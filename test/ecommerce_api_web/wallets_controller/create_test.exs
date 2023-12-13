defmodule EcommerceApiWeb.WalletsController.CreateTest do
  use EcommerceApiWeb.ConnCase, async: true

  alias Test.{Factory, Generators}
  alias EcommerceApi.Customers.CreateSessionToken

  @url "/api/customers/wallets"

  setup do
    customer = Generators.build(:customer)

    {:ok, token} = CreateSessionToken.call(:customer, %{})

    %{customer_id: customer.id, token: token}
  end

  describe "create" do
    test "should return product data", %{
      conn: conn,
      token: token,
      customer_id: customer_id
    } do
      payload = Factory.build(:wallet, customer_id: customer_id, session_token: token)

      conn
      |> post(@url, payload)
      |> json_response(201)
    end

    test "should fail due to empty session_token", %{
      conn: conn,
      customer_id: customer_id
    } do
      payload = Factory.build(:product, customer_id: customer_id)

      conn
      |> post(@url, payload)
      |> json_response(400)
    end
  end
end
