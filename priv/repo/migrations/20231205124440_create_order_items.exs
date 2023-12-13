defmodule EcommerceApi.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items, primary_key: false) do
      add :order_id, references(:orders, type: :binary_id, on_delete: :delete_all)
      add :product_id, references(:products, type: :binary_id, on_delete: :nothing)
    end
  end
end
