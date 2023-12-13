defmodule EcommerceApi.Customers.Wallets.Get do
  alias EcommerceApi.Support.Error
  alias EcommerceApi.Customers.Wallet
  alias EcommerceApi.Repo

  @spec by_id(String.t()) :: {:ok, map()}
  def by_id(id) when is_bitstring(id) do
    case Repo.get(Wallet, id) do
      %Wallet{} = wallet -> {:ok, wallet}
      _ -> Error.build(404, %{wallet: "not found"})
    end
  end

  def by_id(_), do: Error.build(400, %{id: "must be of type string"})
end
