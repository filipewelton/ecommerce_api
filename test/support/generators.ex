defmodule Test.Generators do
  alias Test.JSONParse
  alias Test.Factory
  alias EcommerceApi.Customers.Create, as: CreateCustomer
  alias EcommerceApi.Stores.Products.Create, as: CreateProduct
  alias EcommerceApi.Stores.Orders.Create, as: CreateOrder
  alias EcommerceApi.Customers.Wallets.Create, as: CreateWallet

  def build(:customer) do
    {:ok, customer} =
      Factory.build(:customer)
      |> CreateCustomer.call()

    customer
  end

  def build(:wallet) do
    customer = build(:customer)

    {:ok, wallet} =
      Factory.build(:wallet, customer_id: customer.id)
      |> JSONParse.call()
      |> CreateWallet.call()

    wallet
  end

  def build(:product) do
    {:ok, product} =
      Factory.build(:product)
      |> JSONParse.call()
      |> CreateProduct.call()

    product
  end

  def build(:order) do
    customer = build(:customer)
    product = build(:product)
    store_id = Application.fetch_env!(:ecommerce_api, :store_id)

    {:ok, order, url} =
      Factory.build(:order,
        customer_id: customer.id,
        items_id: [product.id],
        store_id: store_id
      )
      |> JSONParse.call()
      |> CreateOrder.call()

    {order, url}
  end
end
