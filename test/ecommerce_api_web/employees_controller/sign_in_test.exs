defmodule EcommerceApiWeb.EmployeesController.SignInTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  alias Test.JSONParse
  alias EcommerceApi.Stores.User
  alias EcommerceApi.Stores.Users.Create

  @url "/api/stores/employees/sign-in"
  @password Faker.String.base64(12)

  setup do
    data =
      build(:store_employee, password: @password)
      |> JSONParse.call()

    {:ok, %User{} = user} = Create.call(data)

    %{email: user.email}
  end

  describe "sign-in" do
    test "should return employee data", %{conn: conn, email: email} do
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
