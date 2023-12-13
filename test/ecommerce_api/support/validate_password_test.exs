defmodule EcommerceApi.Support.ValidatePasswordTest do
  use ExUnit.Case

  alias EcommerceApi.Support.ValidatePassword
  alias EcommerceApi.Support.Error

  describe "call/1" do
    test "should return :ok" do
      password = Faker.String.base64()
      hash = Pbkdf2.hash_pwd_salt(password)
      response = ValidatePassword.call(hash, password)

      assert :ok = response
    end

    test "should fail due to invalid password" do
      password = Faker.String.base64()
      hash = Pbkdf2.hash_pwd_salt(Faker.String.base64())
      response = ValidatePassword.call(hash, password)

      assert %Error{status: 401, error: %{password: "is invalid"}} = response
    end
  end
end
