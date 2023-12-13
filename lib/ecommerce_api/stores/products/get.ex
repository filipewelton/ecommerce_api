defmodule EcommerceApi.Stores.Products.Get do
  alias EcommerceApi.Support.Error
  alias EcommerceApi.Stores.Product
  alias EcommerceApi.Repo

  def by_id(id) do
    case Repo.get(Product, id) do
      %Product{} = product -> {:ok, product}
      nil -> Error.build(404, %{product: "not found"})
    end
  end
end
