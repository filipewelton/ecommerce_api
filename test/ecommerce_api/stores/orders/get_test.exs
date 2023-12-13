defmodule EcommerceApi.Stores.Orders.GetTest do
  use EcommerceApi.DataCase

  import Test.Generators

  alias EcommerceApi.Stores.Orders.Get
  alias EcommerceApi.Stores.Order
  alias EcommerceApi.Support.Error

  describe "by_id/1" do
    test "should return order data" do
      {order, _url} = build(:order)
      response = Get.by_id(order.id)

      assert {:ok, %Order{}} = response
    end

    test "should fail due to not found id" do
      id = Faker.UUID.v4()
      response = Get.by_id(id)

      assert %Error{status: 404, error: %{order: "not found"}} = response
    end

    test "should fail due to invalid id" do
      id = :rand.uniform()
      response = Get.by_id(id)

      assert %Error{status: 400, error: %{id: "must be of type string"}} = response
    end
  end
end
