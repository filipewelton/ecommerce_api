defmodule EcommerceApi.Repo.Migrations.CreateStoreUserRoles do
  use Ecto.Migration

  def change do
    up = "CREATE TYPE store_user_roles AS ENUM('manager', 'employee')"
    down = "DROP TYPE store_user_roles"

    execute(up, down)
  end
end
