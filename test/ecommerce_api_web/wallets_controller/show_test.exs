defmodule EcommerceApiWeb.WalletsController.ShowTest do
  use EcommerceApiWeb.ConnCase

  alias Test.Generators
  alias EcommerceApi.Customers.CreateSessionToken

  setup do
    wallet = Generators.build(:wallet)

    {:ok, token} = CreateSessionToken.call(:customer, %{})

    %{token: token, id: wallet.id}
  end

  describe "show" do
    test "should return product data", %{conn: conn, id: id, token: token} do
      url = "/api/customers/wallets/#{id}?session_token=#{token}"

      conn
      |> get(url)
      |> json_response(200)
    end

    test "should fail due to id not found", %{conn: conn, token: token} do
      id = Faker.UUID.v4()
      url = "/api/customers/wallets/#{id}?session_token=#{token}"

      conn
      |> get(url)
      |> json_response(404)
    end

    test "should fail due to invalid id", %{conn: conn, token: token} do
      id = nil
      url = "/api/customers/wallets/#{id}?session_token=#{token}"

      conn
      |> get(url)
      |> json_response(404)
    end

    test "should fail due to empty 'session_token'", %{conn: conn, id: id} do
      url = "/api/customers/wallets/#{id}"

      conn
      |> get(url)
      |> json_response(400)
    end
  end
end
