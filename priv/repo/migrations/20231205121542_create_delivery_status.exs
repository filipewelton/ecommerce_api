defmodule EcommerceApi.Repo.Migrations.CreateDeliveryStatus do
  use Ecto.Migration

  def change do
    up =
      "CREATE TYPE delivery_status AS ENUM('pending', 'shipped', 'arrived', 'collected', 'returning', 'returned')"

    down = "DROP TYPE delivery_status"

    execute(up, down)
  end
end
