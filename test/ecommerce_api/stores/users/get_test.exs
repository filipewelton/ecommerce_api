defmodule EcommerceApi.Stores.Users.GetTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias Test.JSONParse
  alias EcommerceApi.Stores.User
  alias EcommerceApi.Stores.Users.{Create, Get}
  alias EcommerceApi.Support.Error

  setup do
    {:ok, %User{id: id, email: email}} =
      build(:store_manager)
      |> JSONParse.call()
      |> Create.call()

    %{id: id, email: email}
  end

  describe "by_id/1" do
    test "should return user data", %{id: id} do
      response = Get.by_id(id)

      assert {:ok, %User{}} = response
    end

    test "should return error 404" do
      id = Faker.UUID.v4()
      response = Get.by_id(id)

      assert %Error{status: 404, error: %{user: "not found"}} = response
    end
  end

  describe "by_email/1" do
    test "should return user data", %{email: email} do
      response = Get.by_email(:manager, email)

      assert {:ok, %User{}} = response
    end

    test "should return error 404", %{email: email} do
      response = Get.by_email(:employee, email)

      assert %Error{status: 404, error: %{user: "not found"}} = response
    end

    test "should fail due to invalid email" do
      email = :rand.uniform()
      response = Get.by_email(:employee, email)

      assert %Error{status: 400, error: %{email: "must be of type string"}} = response
    end
  end
end
