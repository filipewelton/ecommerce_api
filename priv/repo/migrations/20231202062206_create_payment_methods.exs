defmodule EcommerceApi.Repo.Migrations.CreatePaymentMethods do
  use Ecto.Migration

  def change do
    up = "CREATE TYPE payment_methods AS ENUM('debit', 'credit')"
    down = "DROP TYPE payment_methods"

    execute(up, down)
  end
end
