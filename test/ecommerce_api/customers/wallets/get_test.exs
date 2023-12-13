defmodule EcommerceApi.Customers.Wallets.GetTest do
  use EcommerceApi.DataCase

  import Test.Generators

  alias EcommerceApi.Support.Error
  alias EcommerceApi.Customers.Wallet
  alias EcommerceApi.Customers.Wallets.Get

  setup do
    wallet = build(:wallet)

    %{id: wallet.id}
  end

  describe "by_id/1" do
    test "should return wallet data", %{id: id} do
      response = Get.by_id(id)

      assert {:ok, %Wallet{}} = response
    end

    test "should fail due to not found id" do
      id = Faker.UUID.v4()
      response = Get.by_id(id)

      assert %Error{status: 404, error: %{wallet: "not found"}} = response
    end

    test "should fail due to invalid id" do
      id = :rand.uniform()
      response = Get.by_id(id)

      assert %Error{status: 400, error: %{id: "must be of type string"}} = response
    end
  end
end
