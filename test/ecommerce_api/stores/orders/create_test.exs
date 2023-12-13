defmodule EcommerceApi.Stores.Orders.CreateTest do
  use EcommerceApi.DataCase

  import Test.Generators

  alias EcommerceApi
  alias Ecto.Changeset
  alias Test.{JSONParse, Factory}
  alias EcommerceApi.Stores.Order
  alias EcommerceApi.Stores.Orders.Create
  alias EcommerceApi.Support.Error

  setup do
    customer = build(:customer)
    product_1 = build(:product)

    %{
      store_id: Application.fetch_env!(:ecommerce_api, :store_id),
      customer_id: customer.id,
      items_id: [product_1.id]
    }
  end

  describe "call/1" do
    test "should create an order", %{
      store_id: store_id,
      customer_id: cid,
      items_id: iid
    } do
      response =
        Factory.build(:order, customer_id: cid, items_id: iid, store_id: store_id)
        |> JSONParse.call()
        |> Create.call()

      assert {:ok, %Order{}, _checkout_url} = response
    end

    test "should fail due to invalid items_id", %{
      store_id: store_id,
      customer_id: cid
    } do
      iid = nil

      response =
        Factory.build(:order, customer_id: cid, items_id: iid, store_id: store_id)
        |> JSONParse.call()
        |> Create.call()

      assert %Error{status: 400, error: %{items_id: "must be of type list"}} = response
    end
  end

  test "should fail due to empty items_id", %{
    store_id: sid,
    customer_id: cid
  } do
    iid = []

    response =
      Factory.build(:order, customer_id: cid, items_id: iid, store_id: sid)
      |> JSONParse.call()
      |> Create.call()

    assert %Error{status: 400, error: %{items_id: "must be non-empty list"}} = response
  end

  test "should fail due to empty customer_id", %{store_id: sid, items_id: iid} do
    response =
      Factory.build(:order, items_id: iid, store_id: sid)
      |> JSONParse.call()
      |> Create.call()

    assert %Error{status: 400, error: %Changeset{valid?: false}} = response
  end

  test "should fail due to invalid total_price", %{
    store_id: sid,
    items_id: iid,
    customer_id: cid
  } do
    response =
      Factory.build(
        :order,
        items_id: iid,
        store_id: sid,
        customer_id: cid,
        total_price: -1
      )
      |> JSONParse.call()
      |> Create.call()

    assert %Error{status: 400, error: %Changeset{valid?: false}} = response
  end
end
