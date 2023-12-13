defmodule EcommerceApi.Stores.Users.Create do
  alias Ecto.Changeset
  alias EcommerceApi.Repo
  alias EcommerceApi.Stores.User
  alias EcommerceApi.Support.Error

  def call(params) do
    with {:ok, changeset} <- changeset(params),
         {:ok, struct} <- create(changeset) do
      {:ok, struct}
    end
  end

  defp changeset(params) do
    try do
      store_id = Application.fetch_env!(:ecommerce_api, :store_id)
      parsed_params = Map.put(params, "store_id", store_id)

      case User.changeset(parsed_params) do
        %Changeset{valid?: true} = changeset -> {:ok, changeset}
        changeset -> Error.build(400, changeset)
      end
    rescue
      # coveralls-ignore-start
      error in ArgumentError ->
        Error.build(500, error)
        # coveralls-ignore-end
    end
  end

  defp create(changeset) do
    case Repo.insert(changeset) do
      {:ok, struct} -> {:ok, struct}
      {:error, error} -> Error.build(409, error)
    end
  end
end
