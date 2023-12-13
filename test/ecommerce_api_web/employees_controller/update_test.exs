defmodule EcommerceApiWeb.EmployeesController.UpdateTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  alias EcommerceApi.Stores.User
  alias EcommerceApi.Stores.Users.{Create, CreateSessionToken}

  setup do
    {:ok, %User{} = user} = Create.call(build(:store_employee))

    claims = %{
      "id" => user.id,
      "email" => user.email
    }

    {:ok, token} = CreateSessionToken.call(:employee, claims)

    %{
      id: user.id,
      token: token
    }
  end

  describe "update" do
    test "should update employee data", %{conn: conn, id: id, token: token} do
      params = %{
        "password" => Faker.String.base64(12),
        "session_token" => token
      }

      conn
      |> patch("/api/stores/employees/#{id}", params)
      |> json_response(200)
    end

    test "should fail due to not found id", %{conn: conn, token: token} do
      id = Faker.UUID.v4()

      params = %{
        "password" => Faker.String.base64(12),
        "session_token" => token
      }

      conn
      |> patch("/api/stores/employees/#{id}", params)
      |> json_response(404)
    end

    test "should fail due to empty id", %{conn: conn, token: token} do
      params = %{
        "password" => Faker.String.base64(12),
        "session_token" => token
      }

      conn
      |> patch("/api/stores/employees", params)
      |> json_response(404)
    end

    test "should fail due to short password", %{conn: conn, id: id, token: token} do
      params = %{
        "password" => Faker.String.base64(),
        "session_token" => token
      }

      conn
      |> patch("/api/stores/employees/#{id}", params)
      |> json_response(400)
    end
  end
end
