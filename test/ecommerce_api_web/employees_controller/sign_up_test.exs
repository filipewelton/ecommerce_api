defmodule EcommerceApiWeb.EmployeesController.SignUpTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  @url "/api/stores/employees/sign-up"

  describe "sign-up" do
    test "should create an employee", %{conn: conn} do
      payload = build(:store_employee)

      conn
      |> post(@url, payload)
      |> json_response(201)
    end

    test "should fail due to already registered email", %{conn: conn} do
      payload = build(:store_employee)

      conn
      |> post(@url, payload)
      |> json_response(201)

      conn
      |> post(@url, payload)
      |> json_response(409)
    end
  end
end
