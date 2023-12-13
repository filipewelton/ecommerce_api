defmodule EcommerceApi.Support.TokenHandlerTest do
  use ExUnit.Case

  alias EcommerceApi.Support.{Error, TokenHandler}

  @audiences [
    "orders:update",
    "stock:create",
    "stock:delete",
    "stock:get",
    "stock:update"
  ]

  describe "generate_token/2" do
    test "should return a token" do
      claims = %{
        "email" => Faker.Internet.email()
      }

      response = TokenHandler.generate_token(claims, @audiences)

      assert {:ok, _} = response
    end
  end

  describe "validate_token/2" do
    test "should return atom" do
      claims = %{
        "email" => Faker.Internet.email()
      }

      {:ok, token} = TokenHandler.generate_token(claims, @audiences)
      response = TokenHandler.validate_token(token, @audiences)

      assert :ok = response
    end

    test "should faild due to unsigned token" do
      token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG" <>
          "9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

      response = TokenHandler.validate_token(token, @audiences)

      assert %Error{status: 401, error: %{token: "unauthorized"}} = response
    end

    test "should faild due to invalid token" do
      token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG"

      response = TokenHandler.validate_token(token, @audiences)

      assert %Error{status: 401, error: %{token: "unauthorized"}} = response
    end

    test "should fail due to invalid role" do
      claims = %{
        "email" => Faker.Internet.email()
      }

      employee_permissions = [
        "picking:get",
        "picking:remove",
        "picking:update"
      ]

      {:ok, token} = TokenHandler.generate_token(claims, employee_permissions)
      response = TokenHandler.validate_token(token, @audiences)

      assert %Error{status: 401, error: %{token: "unauthorized"}} = response
    end
  end
end
