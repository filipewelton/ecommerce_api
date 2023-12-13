defmodule EcommerceApi.Stores.Product do
  use Ecto.Schema

  import Ecto.Changeset

  alias EcommerceApi.Store
  alias EcommerceApi.Stores.Order

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @fields [
    :name,
    :description,
    :department,
    :labels,
    :photo,
    :price,
    :amount,
    :unit_label,
    :store_id
  ]
  @derive {Jason.Encoder,
           only: [:name, :description, :department, :labels, :photo, :price, :unit_label]}

  schema "products" do
    field :stripe_product_id, :string
    field :stripe_price_id, :string
    field :name, :string
    field :description, :string
    field :department, :string
    field :labels, {:array, :string}
    field :photo, :string
    field :price, :decimal
    field :amount, :decimal
    field :unit_label, :string
    belongs_to :store, Store
    many_to_many :orders, Order, join_through: "order_items", on_delete: :nothing
    timestamps()
  end

  def changeset(values) do
    handle(%__MODULE__{}, values)
  end

  def changeset(struct, values), do: handle(struct, values)

  defp handle(struct, values) do
    struct
    |> cast(values, @fields)
    |> validate_required(@fields)
    |> validate_format(:name, ~r/^([a-zA-Z0-9\s.]+)$/)
    |> validate_length(:description, min: 6, max: 255)
    |> validate_change(:labels, &validate_categories/2)
    |> validate_number(:price, greater_than: 0)
    |> validate_length(:unit_label, max: 3)
    |> unique_constraint(:name)
  end

  defp validate_categories(:labels, values) do
    if length(values) == 0 do
      [labels: "must have at least one label"]
    else
      []
    end
  end
end
