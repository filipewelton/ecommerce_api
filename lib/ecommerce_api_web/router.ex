defmodule EcommerceApiWeb.Router do
  use EcommerceApiWeb, :router

  alias EcommerceApiWeb.Plugs.VerifyUUID

  pipeline :api do
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Phoenix.json_library()

    plug :accepts, ["json"]
    plug VerifyUUID
  end

  scope "/api", EcommerceApiWeb do
    pipe_through :api

    post "/stores/employees/sign-up", EmployeesController, :sign_up
    post "/stores/employees/sign-in", EmployeesController, :sign_in
    resources "/stores/employees", EmployeesController, only: [:update, :delete]

    post "/stores/managers/sign-up", ManagersController, :sign_up
    post "/stores/managers/sign-in", ManagersController, :sign_in
    resources "/stores/managers", ManagersController, only: [:update, :delete]

    resources(
      "/stores/products",
      ProductsController,
      only: [:create, :show, :update]
    )

    resources "/stores/orders", OrdersController, only: [:create, :show, :update]

    post "/customers/sign-up", CustomersController, :sign_up
    post "/customers/sign-in", CustomersController, :sign_in
    resources "/customers", CustomersController, only: [:update, :delete]

    resources "/customers/wallets", WalletsController, only: [:create, :delete, :show]
  end

  scope "/webhooks", EcommerceApiWeb do
    # coveralls-ignore-next-line
    post "/", WebhooksController, :index
  end
end
