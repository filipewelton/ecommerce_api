defmodule EcommerceApiWeb.WalletsController.DeleteTest do
  use EcommerceApiWeb.ConnCase, async: true

  alias Test.Generators
  alias EcommerceApi.Customers.CreateSessionToken

  setup do
    wallet = Generators.build(:wallet)

    {:ok, token} = CreateSessionToken.call(:customer, %{})

    %{id: wallet.id, token: token}
  end

  describe "delete" do
    test "should return status code 204", %{conn: conn, token: token, id: id} do
      conn
      |> delete("/api/customers/wallets/#{id}?session_token=#{token}")
      |> response(204)
    end

    test "should return status 404", %{conn: conn, token: token} do
      id = Faker.UUID.v4()

      conn
      |> delete("/api/customers/wallets/#{id}?session_token=#{token}")
      |> response(404)
    end
  end
end
