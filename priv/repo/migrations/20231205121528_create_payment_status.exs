defmodule EcommerceApi.Repo.Migrations.CreatePaymentStatus do
  use Ecto.Migration

  def change do
    up =
      "CREATE TYPE payment_status AS ENUM('pending', 'expired', 'paid', 'refused', 'refunding', 'refunded')"

    down = "DROP TYPE payment_status"

    execute(up, down)
  end
end
