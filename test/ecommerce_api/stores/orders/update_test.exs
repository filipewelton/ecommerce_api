defmodule EcommerceApi.Stores.Orders.UpdateTest do
  use EcommerceApi.DataCase

  import Test.Generators

  alias Ecto.Changeset
  alias EcommerceApi.Stores.Orders.Update
  alias EcommerceApi.Support.Error
  alias EcommerceApi.Stores.Order

  setup do
    {order, _url} = build(:order)
    %{id: order.id}
  end

  describe "call/1" do
    test "should update order", %{id: id} do
      product = build(:product)

      params = %{
        "id" => id,
        "payment_status" => :refused,
        "items_id" => [product.id]
      }

      response = Update.call(params)

      assert {:ok, %Order{}} = response
    end

    test "should fail due to invalid payment_status", %{id: id} do
      params = %{
        "id" => id,
        "payment_status" => :invalid
      }

      response = Update.call(params)

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end

    test "should fail due to empty id" do
      params = %{
        "payment_status" => :refused
      }

      response = Update.call(params)

      assert %Error{status: 400, error: %{id: "is required"}} = response
    end
  end
end
