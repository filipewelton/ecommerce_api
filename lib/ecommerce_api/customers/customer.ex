defmodule EcommerceApi.Customer do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias EcommerceApi.Stores.Order

  @primary_key {:id, :binary_id, autogenerate: true}
  @creation_fields [:email, :password, :name, :cpf, :cep, :address_number]
  @update_fields [:email, :password, :name, :cep, :address_number]
  @derive {Jason.Encoder, only: [:id, :email, :name, :cep, :address_number]}

  schema "customers" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :name, :string
    field :cpf, :string
    field :cep, :string
    field :address_number, :integer
    has_many :orders, Order, foreign_key: :id
    timestamps()
  end

  def changeset(values) do
    handle_changeset(%__MODULE__{}, values, @creation_fields)
    |> put_password()
  end

  def changeset(struct, values), do: handle_changeset(struct, values, @update_fields)

  defp handle_changeset(struct, values, fields) do
    struct
    |> cast(values, fields)
    |> validate_required(fields)
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> validate_length(:password, min: 12)
    |> validate_length(:name, min: 2)
    |> validate_format(:cpf, ~r/^\d{3}.\d{3}.\d{3}-\d{2}$/)
    |> validate_format(:cep, ~r/^\d{5}-\d{3}$/)
    |> validate_number(:address_number, greater_than: 0)
    |> unique_constraint(:email)
    |> unique_constraint(:cpf)
  end

  defp put_password(%Changeset{valid?: true} = changeset) do
    %{changes: %{password: password}} = changeset
    hash = Pbkdf2.hash_pwd_salt(password)

    change(changeset, %{password_hash: hash})
  end

  defp put_password(changeset), do: changeset
end
