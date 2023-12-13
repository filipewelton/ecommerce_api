defmodule EcommerceApi.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :stripe_product_id, :string, null: false
      add :stripe_price_id, :string, null: false
      add :name, :string, null: false
      add :description, :string, null: false
      add :department, :string, null: false
      add :labels, {:array, :string}, null: false
      add :photo, :string, null: false
      add :price, :decimal, null: false
      add :amount, :decimal, null: false
      add :unit_label, :string, null: false
      add :store_id, references(:stores, type: :binary_id)

      timestamps()
    end

    create unique_index(:products, :name)
  end
end
