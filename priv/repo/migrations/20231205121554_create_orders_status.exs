defmodule EcommerceApi.Repo.Migrations.CreateOrdersStatus do
  use Ecto.Migration

  def change do
    up =
      "CREATE TYPE order_status AS ENUM('processing', 'confirmed', 'picking', 'packing', 'canceled', 'completed')"

    down = "DROP TYPE order_status"

    execute(up, down)
  end
end
