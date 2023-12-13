defmodule EcommerceApi.Customers.Delete do
  alias EcommerceApi.Repo
  alias EcommerceApi.Support.Error
  alias EcommerceApi.Customers.Get

  def call(id) do
    with {:ok, customer} <- Get.by_id(id) do
      delete(customer)
    end
  end

  defp delete(customer) do
    case Repo.delete(customer) do
      {:ok, _} ->
        :ok

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end
end
