defmodule EcommerceApi.Customers.Wallets.Delete do
  alias EcommerceApi.Repo
  alias EcommerceApi.Customers.Wallets.Get
  alias EcommerceApi.Support.Error

  @spec call(String.t()) :: :ok
  def call(id) do
    with {:ok, wallet} <- Get.by_id(id) do
      delete(wallet)
    end
  end

  defp delete(wallet) do
    case Repo.delete(wallet) do
      {:ok, _} ->
        :ok

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end
end
