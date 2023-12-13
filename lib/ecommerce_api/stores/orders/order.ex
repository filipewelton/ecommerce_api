defmodule EcommerceApi.Stores.Order do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Enum
  alias EcommerceApi.{Customer, Store}
  alias EcommerceApi.Stores.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @payment_status [:pending, :expired, :paid, :refused, :refunding, :refunded]
  @delivery_status [:pending, :shipped, :arrived, :collected, :returning, :returned]
  @order_status [:processing, :confirmed, :picking, :packing, :canceled, :completed]
  @creation_fields [
    :total_price,
    :delivery_fee,
    :delivery_date,
    :customer_id,
    :store_id
  ]
  @update_fields [:payment_status, :delivery_date, :order_status]
  @derive {
    Jason.Encoder,
    only: [
      :id,
      :total_price,
      :payment_status,
      :delivery_fee,
      :delivery_status,
      :delivery_date,
      :order_status,
      :customer_id,
      :store_id
    ]
  }

  schema "orders" do
    field :total_price, :decimal
    field :payment_status, Enum, values: @payment_status, default: :pending
    field :delivery_fee, :decimal
    field :delivery_status, Enum, values: @delivery_status, default: :pending
    field :delivery_date, :date
    field :order_status, Enum, values: @order_status, default: :processing
    belongs_to :customer, Customer
    belongs_to :store, Store
    many_to_many :items, Product, join_through: "order_items", on_delete: :nothing

    timestamps()
  end

  def changeset(values, items) do
    handle_changeset(%__MODULE__{}, values, @creation_fields)
    |> put_assoc(:items, items)
  end

  def changeset(:update, struct, values) do
    handle_changeset(struct, values, @update_fields)
  end

  defp handle_changeset(struct, values, fields) do
    struct
    |> cast(values, fields)
    |> validate_required(fields)
    |> validate_number(:total_price, greater_than: 0)
    |> validate_number(:delivery_fee, greater_than: 0)
  end
end
