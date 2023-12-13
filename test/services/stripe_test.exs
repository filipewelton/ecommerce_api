defmodule Services.StripeTest do
  use EcommerceApi.DataCase

  alias Test.Factory
  alias Services.StripeService

  describe "create_product/1" do
    test "should create a product" do
      response =
        Factory.build(:product)
        |> StripeService.create_product()

      assert {:ok, %Stripe.Product{}} = response
    end
  end
end
