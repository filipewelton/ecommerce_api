defmodule EcommerceApi.Stores.Users.CreateSessionToken do
  alias EcommerceApi.Support.TokenHandler

  def call(:manager, claims) do
    audiences = [
      "account:delete",
      "account:update",
      "orders:get",
      "orders:update",
      "stock:create",
      "stock:delete",
      "stock:get",
      "stock:update"
    ]

    TokenHandler.generate_token(claims, audiences)
  end

  def call(:employee, claims) do
    audiences = [
      "account:delete",
      "account:update",
      "picking:get",
      "picking:remove",
      "picking:update"
    ]

    TokenHandler.generate_token(claims, audiences)
  end
end
