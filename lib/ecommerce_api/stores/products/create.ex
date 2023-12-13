defmodule EcommerceApi.Stores.Products.Create do
  alias EcommerceApi.Repo
  alias EcommerceApi.Support.Error
  alias EcommerceApi.Stores.Product
  alias Stripe.Product, as: StripeProduct
  alias Services.StripeService
  alias Ecto.Changeset

  def call(params) do
    with {:ok, changeset} <- cast(params),
         {:ok, stripe_product} <- StripeService.create_product(params),
         {:ok, struct} <- create(changeset, stripe_product) do
      {:ok, struct}
    end
  end

  defp cast(params) do
    try do
      store_id = Application.fetch_env!(:ecommerce_api, :store_id)
      parsed_params = Map.put(params, "store_id", store_id)

      case Product.changeset(parsed_params) do
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

  defp create(%Changeset{} = changeset, %StripeProduct{} = product) do
    payload =
      Changeset.change(changeset, %{
        stripe_product_id: product.id,
        stripe_price_id: product.default_price
      })

    case Repo.insert(payload) do
      {:ok, struct} ->
        {:ok, struct}

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end
end
