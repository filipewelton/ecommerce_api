defmodule EcommerceApi.Stores.Users.DeleteTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias EcommerceApi.Stores.User
  alias EcommerceApi.Stores.Users.{Create, Delete}
  alias EcommerceApi.Support.Error

  setup do
    account = build(:store_manager)
    {:ok, %User{id: id}} = Create.call(account)

    %{id: id}
  end

  describe "call/1" do
    test "should delete user", %{id: id} do
      response = Delete.call(id)
      assert :ok = response
    end

    test "should return error 404" do
      id = Faker.UUID.v4()
      response = Delete.call(id)

      assert %Error{status: 404, error: %{user: "not found"}} = response
    end
  end
end
