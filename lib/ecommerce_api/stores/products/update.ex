defmodule EcommerceApi.Stores.Products.Update do
  alias EcommerceApi.Repo
  alias EcommerceApi.Support.Error
  alias Ecto.Changeset
  alias EcommerceApi.Stores.Product
  alias EcommerceApi.Stores.Products.Get

  def call(params) do
    with :ok <- has_id(params),
         {:ok, account} <- Get.by_id(params["id"]),
         {:ok, changeset} <- changeset(account, params),
         {:ok, updated_data} <- update(changeset) do
      {:ok, updated_data}
    end
  end

  defp has_id(params) do
    case Map.has_key?(params, "id") do
      true -> :ok
      false -> Error.build(400, %{id: "is required"})
    end
  end

  defp changeset(struct, params) do
    case Product.changeset(struct, params) do
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
