defmodule EcommerceApi.Stores.Orders.Get do
  alias EcommerceApi.Repo
  alias EcommerceApi.Stores.Order
  alias EcommerceApi.Support.Error

  def by_id(id) when is_bitstring(id) do
    case Repo.get(Order, id) do
      %Order{} = order -> {:ok, order}
      nil -> Error.build(404, %{order: "not found"})
    end
  end

  def by_id(_), do: Error.build(400, %{id: "must be of type string"})
end
