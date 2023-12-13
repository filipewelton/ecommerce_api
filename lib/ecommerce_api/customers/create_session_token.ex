defmodule EcommerceApi.Customers.CreateSessionToken do
  alias EcommerceApi.Support.TokenHandler

  def call(:customer, claims) do
    audiences = [
      "account:delete",
      "account:update",
      "orders:create",
      "orders:get",
      "orders:update",
      "wallets:create",
      "wallets:delete",
      "wallets:get"
    ]

    TokenHandler.generate_token(claims, audiences)
  end
end
