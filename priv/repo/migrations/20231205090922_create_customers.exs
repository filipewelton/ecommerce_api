defmodule EcommerceApi.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :name, :string, null: false
      add :cpf, :string, null: false
      add :cep, :string, null: false
      add :address_number, :integer, null: false

      timestamps()
    end

    create unique_index(:customers, :email)
    create unique_index(:customers, :cpf)
  end
end
