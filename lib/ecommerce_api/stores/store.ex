defmodule EcommerceApi.Store do
  use Ecto.Schema

  import Ecto.Changeset

  alias EcommerceApi.Stores.{User, Product, Order}

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [:id, :cnpj, :name, :cep, :address_number]

  schema "stores" do
    field :cnpj, :string
    field :name, :string
    field :cep, :string
    field :address_number, :integer
    has_many :users, User
    has_many :products, Product
    has_many :orders, Order, foreign_key: :id
    timestamps()
  end

  def changeset(values) do
    %__MODULE__{}
    |> cast(values, @fields)
    |> validate_required(@fields)
  end
end
