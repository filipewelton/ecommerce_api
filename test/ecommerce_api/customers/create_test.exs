defmodule EcommerceApi.Customers.CreateTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias Ecto.Changeset
  alias EcommerceApi.Customer
  alias EcommerceApi.Customers.Create
  alias EcommerceApi.Support.Error
  alias Test.JSONParse

  describe "call/1" do
    test "should create a customer" do
      response =
        build(:customer)
        |> Create.call()

      assert {:ok, %Customer{}} = response
    end

    test "should fail due to invalid cpf" do
      response =
        build(:customer, cpf: Faker.String.base64())
        |> JSONParse.call()
        |> Create.call()

      assert %Error{status: 400, error: %Changeset{valid?: false}} = response
    end
  end
end
