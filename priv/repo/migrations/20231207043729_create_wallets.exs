defmodule EcommerceApi.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :payment_method, :payment_methods, null: false
      add :card_number, :string, null: false
      add :verification_code, :integer, null: false
      add :expiration_date, :date, null: false
      add :customer_id, references(:customers, type: :binary_id, on_delete: :nothing)

      timestamps()
    end
  end
end
