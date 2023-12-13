defmodule EcommerceApi.Customers.UpdateTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias Ecto.Changeset
  alias Test.JSONParse
  alias EcommerceApi.Customer
  alias EcommerceApi.Customers.{Create, Update}
  alias EcommerceApi.Support.Error

  setup do
    {:ok, %Customer{id: id}} =
      build(:customer)
      |> JSONParse.call()
      |> Create.call()

    %{id: id}
  end

  describe "update/1" do
    test "should update customer data", %{id: id} do
      params = %{
        "id" => id,
        "password" => Faker.String.base64(12)
      }

      response = Update.call(params)

      assert {:ok, %Customer{}} = response
    end

    test "should fail due to not found id" do
      id = Faker.UUID.v4()

      params = %{
        "id" => id,
        "password" => Faker.String.base64(12)
      }

      response = Update.call(params)

      assert %Error{status: 404, error: %{customer: "not found"}} = response
    end

    test "should fail due to empty id" do
      params = %{
        "password" => Faker.String.base64(12),
        "categories" => []
      }

      response = Update.call(params)

      assert %Error{status: 400, error: %{id: "is required"}} = response
    end

    test "should fail due to short password", %{id: id} do
      params = %{
        "id" => id,
        "password" => Faker.String.base64(),
        "categories" => []
      }

      response = Update.call(params)

      assert %Error{status: 400, error: %Changeset{}} = response
    end
  end
end
