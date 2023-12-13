defmodule EcommerceApi.Customers.DeleteTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias EcommerceApi.Customer
  alias EcommerceApi.Customers.{Create, Delete}
  alias EcommerceApi.Support.Error

  setup do
    {:ok, %Customer{id: id}} =
      build(:customer)
      |> Create.call()

    %{id: id}
  end

  describe "call/1" do
    test "should delete customer", %{id: id} do
      response = Delete.call(id)
      assert :ok = response
    end

    test "should fail due to not found customer" do
      id = Faker.UUID.v4()
      response = Delete.call(id)

      assert %Error{status: 404, error: %{customer: "not found"}} = response
    end
  end
end
