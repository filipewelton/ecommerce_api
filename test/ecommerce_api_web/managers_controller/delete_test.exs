defmodule EcommerceApiWeb.ManagersController.DeleteTest do
  use EcommerceApiWeb.ConnCase, async: true

  import Test.Factory

  alias EcommerceApi.Stores.User
  alias EcommerceApi.Stores.Users.{Create, CreateSessionToken}

  setup do
    {:ok, %User{} = user} = Create.call(build(:store_manager))

    claims = %{
      "id" => user.id,
      "email" => user.email
    }

    {:ok, token} = CreateSessionToken.call(:manager, claims)

    %{
      id: user.id,
      token: token
    }
  end

  describe "delete" do
    test "should delete manager", %{conn: conn, id: id, token: token} do
      params = %{"session_token" => token}

      conn
      |> delete("/api/stores/managers/#{id}", params)
      |> response(204)
    end

    test "should fail due to invalid session_token", %{conn: conn, id: id} do
      params = %{"session_token" => Faker.String.base64(64)}

      conn
      |> delete("/api/stores/managers/#{id}", params)
      |> response(401)
    end

    test "should fail due to unregistered id", %{conn: conn, token: token} do
      id = Faker.UUID.v4()
      params = %{"session_token" => token}

      conn
      |> delete("/api/stores/managers/#{id}", params)
      |> json_response(404)
    end

    test "should fail due to invalid id", %{conn: conn, token: token} do
      id = Faker.String.base64()
      params = %{"session_token" => token}

      conn
      |> delete("/api/stores/managers/#{id}", params)
      |> json_response(404)
    end

    test "should fail due to empty session_token", %{conn: conn, id: id} do
      params = %{}

      conn
      |> delete("/api/stores/managers/#{id}", params)
      |> response(400)
    end

    test "should fail due to an invalid type session_token", %{conn: conn, id: id} do
      params = %{"session_token" => :rand.uniform(10)}

      conn
      |> delete("/api/stores/managers/#{id}", params)
      |> response(400)
    end
  end
end
