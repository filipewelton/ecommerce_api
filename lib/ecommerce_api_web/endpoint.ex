defmodule EcommerceApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :ecommerce_api

  @session_options [
    store: :cookie,
    key: "_ecommerce_api_key",
    signing_salt: "+JkP+iYS",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :ecommerce_api,
    gzip: false,
    only: EcommerceApiWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :ecommerce_api
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug EcommerceApiWeb.Router
end
