defmodule EcommerceApi do
  alias EcommerceApi.Stores.Users.Create, as: CreateStoreUser
  alias EcommerceApi.Stores.Users.CreateSessionToken, as: CreateUserToken
  alias EcommerceApi.Stores.Users.Get, as: GetStoreUser
  alias EcommerceApi.Stores.Users.Update, as: UpdateStoreUser
  alias EcommerceApi.Stores.Users.Delete, as: DeleteStoreUser
  alias EcommerceApi.Support.ValidatePassword
  alias EcommerceApi.Stores.Products.Create, as: CreateProduct
  alias EcommerceApi.Stores.Products.Get, as: GetProduct
  alias EcommerceApi.Stores.Products.Update, as: UpdateProduct
  alias EcommerceApi.Customers.Create, as: CreateCustomer
  alias EcommerceApi.Customers.Delete, as: DeleteCustomer
  alias EcommerceApi.Customers.Get, as: GetCustomer
  alias EcommerceApi.Customers.Update, as: UpdateCustomer
  alias EcommerceApi.Customers.CreateSessionToken, as: CreateCustomerToken
  alias EcommerceApi.Stores.Orders.Create, as: CreateOrder
  alias EcommerceApi.Stores.Orders.Get, as: GetOrder
  alias EcommerceApi.Stores.Orders.Update, as: UpdateOrder
  alias EcommerceApi.Customers.Wallets.Create, as: CreateWallet
  alias EcommerceApi.Customers.Wallets.Delete, as: DeleteWallet
  alias EcommerceApi.Customers.Wallets.Get, as: GetWallet

  defdelegate create_user_token(atom, claims), to: CreateUserToken, as: :call

  defdelegate create_store_user(params), to: CreateStoreUser, as: :call

  defdelegate get_store_user_by_email(user_role, params), to: GetStoreUser, as: :by_email

  defdelegate update_store_user(params), to: UpdateStoreUser, as: :call

  defdelegate delete_store_user(id), to: DeleteStoreUser, as: :call

  defdelegate validate_password(stored_hash, password),
    to: ValidatePassword,
    as: :call

  defdelegate create_product(params), to: CreateProduct, as: :call

  defdelegate get_product(id), to: GetProduct, as: :by_id

  defdelegate update_product(params), to: UpdateProduct, as: :call

  defdelegate create_customer(params), to: CreateCustomer, as: :call

  defdelegate delete_customer(id), to: DeleteCustomer, as: :call

  defdelegate get_customer_by_email(email), to: GetCustomer, as: :by_email

  defdelegate update_customer(params), to: UpdateCustomer, as: :call

  defdelegate create_customer_token(atom, claims), to: CreateCustomerToken, as: :call

  defdelegate create_order(params), to: CreateOrder, as: :call

  defdelegate get_order(id), to: GetOrder, as: :by_id

  defdelegate update_order(params), to: UpdateOrder, as: :call

  defdelegate create_wallet(params), to: CreateWallet, as: :call

  defdelegate delete_wallet(id), to: DeleteWallet, as: :call

  defdelegate get_wallet(id), to: GetWallet, as: :by_id
end
