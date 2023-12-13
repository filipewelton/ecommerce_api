defmodule EcommerceApi.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :total_price, :decimal, null: false
      add :payment_status, :payment_status, null: false
      add :delivery_fee, :decimal, null: false
      add :delivery_status, :delivery_status, null: false
      add :delivery_date, :date, null: false
      add :order_status, :order_status, null: false
      add :customer_id, references(:customers, type: :binary_id)
      add :store_id, references(:stores, type: :binary_id)
      timestamps()
    end
  end
end
