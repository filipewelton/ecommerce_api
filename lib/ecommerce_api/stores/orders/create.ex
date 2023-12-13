defmodule EcommerceApi.Stores.Orders.Create do
  import Ecto.Query

  alias Ecto.Changeset
  alias EcommerceApi.{Repo, Customer}
  alias EcommerceApi.Stores.{Order, Product}
  alias EcommerceApi.Support.Error
  alias Services.StripeService

  @spec call(map()) :: {:ok, map(), String.t()}
  def call(params) do
    with {:ok, items} <- check_items_id(params),
         stripe_items <- parse_items(params, items),
         {:ok, changeset} <- cast(params, items),
         {:ok, order} <- insert(changeset),
         {:ok, url} <- create_checkout_session(stripe_items, order) do
      {:ok, order, url}
    end
  end

  defp check_items_id(%{"items_id" => ids}) when not is_list(ids) do
    Error.build(400, %{items_id: "must be of type list"})
  end

  defp check_items_id(%{"items_id" => ids}) when ids == [] do
    Error.build(400, %{items_id: "must be non-empty list"})
  end

  defp check_items_id(%{"items_id" => ids}) do
    query = from p in Product, where: p.id in ^ids
    {:ok, Repo.all(query)}
  end

  defp parse_items(%{"items_id" => ids}, products) do
    Enum.frequencies_by(ids, fn id -> id end)
    |> Enum.to_list()
    |> Enum.map(fn {id, qnt} ->
      product = Enum.find(products, fn %Product{} = e -> e.id == id end)
      %{price: product.stripe_price_id, quantity: qnt}
    end)
  end

  defp cast(params, items) do
    store_id = Application.fetch_env!(:ecommerce_api, :store_id)
    parsed_params = Map.put(params, "store_id", store_id)

    case Order.changeset(parsed_params, items) do
      %Changeset{valid?: true} = changeset -> {:ok, changeset}
      changeset -> Error.build(400, changeset)
    end
  end

  defp insert(changeset) do
    case Repo.insert(changeset) do
      {:ok, _} = returns ->
        returns

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end

  defp create_checkout_session(items, order) do
    %Order{
      id: id,
      customer: %Customer{email: email}
    } = Repo.preload(order, :customer)

    StripeService.create_checkout_session(items, email, id)
  end
end
