defmodule EcommerceApi.Stores.Products.GetTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias EcommerceApi.Stores.Product
  alias EcommerceApi.Stores.Products.Create
  alias EcommerceApi.Stores.Products.Get
  alias EcommerceApi.Support.Error

  setup do
    product = build(:product)

    {:ok, %Product{} = product} = Create.call(product)

    %{id: product.id}
  end

  describe "by_id/1" do
    test "should return product data", %{id: id} do
      response = Get.by_id(id)

      assert {:ok, %Product{}} = response
    end

    test "should fail due to not found id" do
      id = Faker.UUID.v4()
      response = Get.by_id(id)

      assert %Error{status: 404, error: %{product: "not found"}} = response
    end
  end
end
