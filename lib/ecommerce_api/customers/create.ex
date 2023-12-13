defmodule EcommerceApi.Customers.Create do
  alias EcommerceApi.Repo
  alias EcommerceApi.Support.Error
  alias Ecto.Changeset
  alias EcommerceApi.Customer

  def call(params) do
    with {:ok, changeset} <- changeset(params),
         {:ok, _} = return <- create(changeset) do
      return
    end
  end

  defp changeset(params) do
    case Customer.changeset(params) do
      %Changeset{valid?: true} = changeset -> {:ok, changeset}
      changeset -> Error.build(400, changeset)
    end
  end

  defp create(changeset) do
    case Repo.insert(changeset) do
      {:ok, _} = return ->
        return

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(409, error)
    end
  end
end
