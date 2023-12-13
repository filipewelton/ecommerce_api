defmodule Services.StripeService do
  require Decimal

  alias EcommerceApi.Support.Error
  alias Stripe.Checkout.Session

  @url "http://localhost:4000/orders"

  @spec create_checkout_session(list(), String.t(), String.t()) :: {:ok, String.t()}
  def create_checkout_session(items, email, order_id) do
    params = %{
      ui_mode: :hosted,
      success_url: "#{@url}/success",
      cancel_url: "#{@url}/cancel",
      line_items: items,
      mode: :payment,
      submit_type: :pay,
      payment_method_types: [:card],
      customer_email: email,
      payment_intent_data: %{
        "metadata" => %{
          "order_id" => order_id
        }
      }
    }

    case Stripe.Checkout.Session.create(params) do
      {:ok, %Session{} = session} ->
        {:ok, session.url}

      {:error, error} ->
        # coveralls-ignore-next-line
        Error.build(500, error)
    end
  end

  def create_product(product) do
    params = %{
      active: true,
      default_price_data: %{
        currency: "BRL",
        unit_amount_decimal: parse_price(product["price"])
      },
      description: product["description"],
      name: product["name"],
      images: [product["photo"]],
      unit_label: product["unit_label"]
    }

    Stripe.Product.create(params)
  end

  defp parse_price(price) when Decimal.is_decimal(price) do
    Decimal.to_string(price)
    |> String.replace(~r/[,.]/, "")
  end

  defp parse_price(price), do: String.replace(price, ~r/[.,]/, "")
end
