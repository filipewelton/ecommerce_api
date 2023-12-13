defmodule EcommerceApi.Stores.Products.CreateTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias Ecto.Changeset
  alias Test.JSONParse
  alias EcommerceApi.Stores.Product
  alias EcommerceApi.Stores.Products.Create
  alias EcommerceApi.Support.Error

  describe "call/1" do
    test "should create a product" do
      response =
        build(:product)
        |> Create.call()

      assert {:ok, %Product{}} = response
    end

    test "should fail due to invalid price" do
      response =
        build(:product, price: -1)
        |> JSONParse.call()
        |> Create.call()

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end

    test "should fail due to empty labels" do
      response =
        build(:product, labels: [])
        |> JSONParse.call()
        |> Create.call()

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end
  end
end
