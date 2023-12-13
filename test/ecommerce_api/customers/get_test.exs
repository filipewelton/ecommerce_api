defmodule EcommerceApi.Customers.GetTest do
  use EcommerceApi.DataCase

  import Test.Factory

  alias EcommerceApi.Customer
  alias EcommerceApi.Customers.{Create, Get}
  alias EcommerceApi.Support.Error

  setup do
    {:ok, %Customer{id: id, email: email}} =
      build(:customer)
      |> Create.call()

    %{id: id, email: email}
  end

  describe "by_id/1" do
    test "should return user data", %{id: id} do
      response = Get.by_id(id)

      assert {:ok, %Customer{}} = response
    end

    test "should return error 404" do
      id = Faker.UUID.v4()
      response = Get.by_id(id)

      assert %Error{status: 404, error: %{customer: "not found"}} = response
    end
  end

  describe "by_email/1" do
    test "should return user data", %{email: email} do
      response = Get.by_email(email)

      assert {:ok, %Customer{}} = response
    end

    test "should fail due to not found customer", %{} do
      email = Faker.Internet.email()
      response = Get.by_email(email)

      assert %Error{status: 404, error: %{customer: "not found"}} = response
    end
  end
end
