defmodule EcommerceApi.Customers.Wallets.DeleteTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias Test.JSONParse
  alias EcommerceApi.Customer
  alias EcommerceApi.Customers.Wallet
  alias EcommerceApi.Customers.Wallets.Create, as: CreateWallet
  alias EcommerceApi.Customers.Create, as: CreateCustomer
  alias EcommerceApi.Customers.Wallets.Delete

  setup do
    {:ok, %Customer{} = customer} =
      build(:customer)
      |> JSONParse.call()
      |> CreateCustomer.call()

    {:ok, %Wallet{} = wallet} =
      build(:wallet, customer_id: customer.id)
      |> JSONParse.call()
      |> CreateWallet.call()

    %{id: wallet.id}
  end

  describe "call/1" do
    test "should delete wallet", %{id: id} do
      response = Delete.call(id)

      assert :ok = response
    end
  end
end
