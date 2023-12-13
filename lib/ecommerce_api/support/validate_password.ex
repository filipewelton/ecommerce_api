defmodule EcommerceApi.Support.ValidatePassword do
  alias EcommerceApi.Support.Error

  def call(stored_hash, password) do
    case Pbkdf2.verify_pass(password, stored_hash) do
      true -> :ok
      false -> Error.build(401, %{password: "is invalid"})
    end
  end
end
