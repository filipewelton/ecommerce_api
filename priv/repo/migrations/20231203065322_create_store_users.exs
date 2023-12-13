defmodule EcommerceApi.Repo.Migrations.CreateStoreUsers do
  use Ecto.Migration

  def change do
    create table(:store_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :role, :store_user_roles, null: false

      add :store_id,
          references(
            :stores,
            type: :binary_id,
            name: :store_users_fkey
          )

      timestamps()
    end

    create unique_index(:store_users, [:email])
  end
end
