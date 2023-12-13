defmodule EcommerceApi.Stores.Users.Delete do
  alias EcommerceApi.Repo
  alias EcommerceApi.Stores.Users.Get
  alias EcommerceApi.Support.Error

  def call(id) do
    with {:ok, struct} <- Get.by_id(id),
         :ok <- delete(struct) do
      :ok
    end
  end

  defp delete(struct) do
    case Repo.delete(struct) do
      {:ok, _} ->
        :ok

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end
end
