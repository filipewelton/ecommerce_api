defmodule EcommerceApi.Stores.Products.UpdateTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias Ecto.Changeset
  alias EcommerceApi.Stores.Product
  alias EcommerceApi.Stores.Products.{Create, Update}
  alias EcommerceApi.Support.Error

  setup do
    product = build(:product)

    {:ok, %Product{} = product} = Create.call(product)

    %{id: product.id}
  end

  describe "call/1" do
    test "should update product data", %{id: id} do
      params = %{
        "id" => id,
        "department" => Faker.Commerce.department()
      }

      response = Update.call(params)

      assert {:ok, %Product{}} = response
    end

    test "should fail when price is lower 0", %{id: id} do
      params = %{
        "id" => id,
        "price" => Decimal.new("-10")
      }

      response = Update.call(params)

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end

    test "should fail due to empty id" do
      params = %{
        "price" => Decimal.new("-10")
      }

      response = Update.call(params)

      assert %Error{status: 400, error: %{id: "is required"}} = response
    end
  end
end
