defmodule EcommerceApiWeb.CustomersController.DeleteTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  alias EcommerceApi.Customer
  alias EcommerceApi.Customers.{Create, CreateSessionToken}

  setup do
    {:ok, %Customer{} = customer} = Create.call(build(:customer))

    claims = %{
      "id" => customer.id,
      "email" => customer.email
    }

    {:ok, token} = CreateSessionToken.call(:customer, claims)

    %{
      id: customer.id,
      token: token
    }
  end

  describe "delete" do
    test "should delete customer", %{conn: conn, id: id, token: token} do
      conn
      |> delete("/api/customers/#{id}?session_token=#{token}")
      |> response(204)
    end

    test "should fail due to unregistered 'id'", %{conn: conn, token: token} do
      id = Faker.UUID.v4()

      conn
      |> delete("/api/customers/#{id}?session_token=#{token}")
      |> json_response(404)
    end

    test "should fail due to invalid 'session_token'", %{conn: conn, id: id} do
      token = Faker.String.base64(64)

      conn
      |> delete("/api/customers/#{id}?session_token=#{token}")
      |> response(401)
    end

    test "should fail due to empty 'session_token'", %{conn: conn, id: id} do
      conn
      |> delete("/api/customers/#{id}")
      |> response(400)
    end
  end
end
