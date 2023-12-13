defmodule EcommerceApi.Stores.Orders.Update do
  alias EcommerceApi.Repo
  alias EcommerceApi.Support.Error
  alias Ecto.Changeset
  alias EcommerceApi.Stores.Order
  alias EcommerceApi.Stores.Orders.Get

  @spec call(map()) :: {:ok, %Order{}} | Error
  def call(params) do
    with {:ok, %Order{} = order} <- get_order(params),
         {:ok, changeset} <- changeset(order, params),
         {:ok, updated_data} <- update(changeset) do
      {:ok, updated_data}
    end
  end

  defp get_order(%{"id" => id}) when is_bitstring(id), do: Get.by_id(id)

  defp get_order(_), do: Error.build(400, %{id: "is required"})

  @spec changeset(map(), map()) :: {:ok, map()} | Error
  defp changeset(struct, params) do
    case Order.changeset(:update, struct, params) do
      %Changeset{valid?: true} = changeset -> {:ok, changeset}
      changeset -> Error.build(400, changeset)
    end
  end

  defp update(changeset) do
    case Repo.update(changeset) do
      {:ok, _} = updated_data ->
        updated_data

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end
end
