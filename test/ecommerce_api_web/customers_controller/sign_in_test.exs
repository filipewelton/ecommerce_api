defmodule EcommerceApiWeb.CustomersController.SignInTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  alias Test.JSONParse
  alias EcommerceApi.Customer
  alias EcommerceApi.Customers.Create

  @url "/api/customers/sign-in"
  @password Faker.String.base64(12)

  setup do
    {:ok, %Customer{} = customer} =
      build(:customer, password: @password)
      |> JSONParse.call()
      |> Create.call()

    %{email: customer.email}
  end

  describe "sign-in" do
    test "should return customer data", %{conn: conn, email: email} do
      payload = %{
        "email" => email,
        "password" => @password
      }

      conn
      |> post(@url, payload)
      |> json_response(200)
    end

    test "should fail due to not found email", %{conn: conn} do
      email = Faker.Internet.email()

      payload = %{
        "email" => email,
        "password" => @password
      }

      conn
      |> post(@url, payload)
      |> json_response(404)
    end
  end
end
