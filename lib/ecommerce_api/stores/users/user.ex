defmodule EcommerceApi.Stores.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.{Changeset, Enum}
  alias EcommerceApi.Store

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @roles [:manager, :employee]
  @creation_fields [:name, :email, :password, :role, :store_id]
  @update_fields [:password]
  @derive {Jason.Encoder, only: [:id, :name, :email, :role]}

  schema "store_users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, Enum, values: @roles
    belongs_to :store, Store
    timestamps()
  end

  def changeset(values), do: handle(%__MODULE__{}, values, @creation_fields)

  def changeset(struct, values), do: handle(struct, values, @update_fields)

  defp handle(struct, values, fields) do
    struct
    |> cast(values, fields)
    |> validate_required(fields)
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> validate_length(:password, min: 12)
    |> unique_constraint(:email)
    |> put_password()
  end

  defp put_password(%Changeset{valid?: true} = changeset) do
    %{changes: %{password: password}} = changeset
    hash = Pbkdf2.hash_pwd_salt(password)

    change(changeset, %{password_hash: hash})
  end

  defp put_password(changeset), do: changeset
end
