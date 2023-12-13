defmodule EcommerceApiWeb.OrdersController.UpdateTest do
  use EcommerceApiWeb.ConnCase, async: true

  alias Test.Generators
  alias EcommerceApi.Customers.CreateSessionToken

  @url "/api/stores/orders"

  setup do
    {order, _url} = Generators.build(:order)

    {:ok, token} = CreateSessionToken.call(:customer, %{})

    %{
      token: token,
      order_id: order.id
    }
  end

  describe "update" do
    test "should return status code 200", %{
      conn: conn,
      token: token,
      order_id: order_id
    } do
      payload = %{
        "session_token" => token,
        "order_status" => :canceled
      }

      conn
      |> patch("#{@url}/#{order_id}", payload)
      |> json_response(200)
    end

    test "should return status code 404", %{conn: conn, token: token} do
      id = Faker.UUID.v4()

      payload = %{
        "session_token" => token,
        "order_status" => :canceled
      }

      conn
      |> patch("#{@url}/#{id}", payload)
      |> json_response(404)
    end
  end
end
