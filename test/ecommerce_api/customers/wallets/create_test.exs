defmodule EcommerceApi.Customers.Wallets.CreateTest do
  use EcommerceApi.DataCase

  alias Ecto.Changeset
  alias Test.{Factory, Generators, JSONParse}
  alias EcommerceApi.Customers.Wallet
  alias EcommerceApi.Customers.Wallets.Create
  alias EcommerceApi.Support.Error

  setup do
    customer = Generators.build(:customer)

    %{customer_id: customer.id}
  end

  describe "call/1" do
    test "should create a wallet with Mastercard card", %{customer_id: id} do
      response =
        Factory.build(:wallet, customer_id: id, card_number: "2223000048400011")
        |> JSONParse.call()
        |> Create.call()

      assert {:ok, %Wallet{}} = response
    end

    test "should create a wallet with American Express card", %{customer_id: id} do
      response =
        Factory.build(:wallet, customer_id: id, card_number: "371449635398431")
        |> JSONParse.call()
        |> Create.call()

      assert {:ok, %Wallet{}} = response
    end

    test "should create a wallet with Diners Club card", %{customer_id: id} do
      response =
        Factory.build(:wallet, customer_id: id, card_number: "36259600000004")
        |> JSONParse.call()
        |> Create.call()

      assert {:ok, %Wallet{}} = response
    end

    test "should create a wallet with Discover card", %{customer_id: id} do
      response =
        Factory.build(:wallet, customer_id: id, card_number: "6011238448045690")
        |> JSONParse.call()
        |> Create.call()

      assert {:ok, %Wallet{}} = response
    end

    test "should fail due to invalid card_number", %{customer_id: id} do
      response =
        Factory.build(:wallet, customer_id: id, card_number: Faker.String.base64())
        |> JSONParse.call()
        |> Create.call()

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end

    test "should fail fail due to expired card", %{customer_id: id} do
      response =
        Factory.build(:wallet, customer_id: id, expiration_date: Faker.Date.backward(100))
        |> JSONParse.call()
        |> Create.call()

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end

    test "should fail due to invalid payment_method", %{customer_id: id} do
      response =
        Factory.build(:wallet, customer_id: id, payment_method: :money)
        |> JSONParse.call()
        |> Create.call()

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end
  end
end
