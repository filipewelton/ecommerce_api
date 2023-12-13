defmodule EcommerceApiWeb.CustomersController.UpdateTest do
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

  describe "update" do
    test "should update customer data", %{conn: conn, id: id, token: token} do
      params = %{
        "password" => Faker.String.base64(12),
        "session_token" => token
      }

      conn
      |> patch("/api/customers/#{id}", params)
      |> json_response(200)
    end

    test "should fail due to not found id", %{conn: conn, token: token} do
      id = Faker.UUID.v4()

      params = %{
        "password" => Faker.String.base64(12),
        "session_token" => token
      }

      conn
      |> patch("/api/customers/#{id}", params)
      |> json_response(404)
    end

    test "should fail due to empty id", %{conn: conn, token: token} do
      params = %{
        "password" => Faker.String.base64(12),
        "session_token" => token
      }

      conn
      |> patch("/api/customers", params)
      |> json_response(404)
    end

    test "should fail due to short password", %{conn: conn, id: id, token: token} do
      params = %{
        "password" => Faker.String.base64(),
        "session_token" => token
      }

      conn
      |> patch("/api/customers/#{id}", params)
      |> json_response(400)
    end
  end
end
