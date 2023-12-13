defmodule EcommerceApi.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :cnpj, :string, null: false
      add :cep, :string, null: false
      add :address_number, :integer, null: false
      timestamps()
    end

    create unique_index(:stores, :cnpj)
  end
end
