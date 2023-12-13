defmodule EcommerceApi.Stores.Users.CreateTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias Ecto.Changeset
  alias Test.JSONParse
  alias EcommerceApi.Stores.User
  alias EcommerceApi.Stores.Users.Create
  alias EcommerceApi.Support.Error

  describe "call/1" do
    test "should create a user" do
      account = JSONParse.call(build(:store_manager))
      response = Create.call(account)

      assert {:ok, %User{}} = response
    end

    test "should fail because of short password" do
      account =
        build(:store_manager, password: Faker.String.base64())
        |> JSONParse.call()

      response = Create.call(account)

      assert %Error{status: 400, error: %Changeset{}} = response
    end

    test "should fail because of conflict" do
      account = JSONParse.call(build(:store_manager))
      Create.call(account)
      response = Create.call(account)

      assert %Error{status: 409, error: %Changeset{}} = response
    end
  end
end
