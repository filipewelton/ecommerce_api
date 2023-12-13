defmodule EcommerceApiWeb.CustomersController.SignUpTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  @url "/api/customers/sign-up"

  describe "sign-up" do
    test "should create an customer", %{conn: conn} do
      payload = build(:customer)

      conn
      |> post(@url, payload)
      |> json_response(201)
    end

    test "should fail due to already registered email", %{conn: conn} do
      payload = build(:customer)

      conn
      |> post(@url, payload)
      |> json_response(201)

      conn
      |> post(@url, payload)
      |> json_response(409)
    end
  end
end
