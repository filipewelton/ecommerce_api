defmodule EcommerceApi.Customers.Wallet do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Enum
  alias EcommerceApi.Customer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @payment_methods [:debit, :credit]
  @fields [
    :payment_method,
    :card_number,
    :verification_code,
    :expiration_date,
    :customer_id
  ]
  @derive {Jason.Encoder, only: @fields ++ [:id]}

  schema "wallets" do
    field :payment_method, Enum, values: @payment_methods
    field :card_number, :string
    field :verification_code, :integer
    field :expiration_date, :date
    belongs_to :customer, Customer
    timestamps()
  end

  def changeset(values) do
    %__MODULE__{}
    |> cast(values, @fields)
    |> validate_required(@fields)
    |> validate_change(:card_number, &validate_card_number/2)
    |> validate_number(:verification_code, greater_than: 99, less_than: 10000)
    |> validate_change(:expiration_date, &validate_expiration_date/2)
  end

  defp validate_card_number(:card_number, number) do
    cond do
      # Visa
      Regex.match?(~r/^4[0-9]{12}(?:[0-9]{3})?$/, number) ->
        []

      # Mastercard
      Regex.match?(
        ~r/^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$/,
        number
      ) ->
        []

      # American Express
      Regex.match?(~r/^3[47][0-9]{13}$/, number) ->
        []

      # Diners Club
      Regex.match?(~r/^3(?:0[0-5]|[68][0-9])[0-9]{11}$/, number) ->
        []

      # Discover
      Regex.match?(~r/^6(?:011|5[0-9]{2})[0-9]{12}$/, number) ->
        []

      true ->
        [card_number: "is invalid"]
    end
  end

  defp validate_expiration_date(:expiration_date, date) do
    today = Date.utc_today()

    case Date.compare(date, today) do
      :gt -> []
      _ -> [expiration_date: "expired"]
    end
  end
end
