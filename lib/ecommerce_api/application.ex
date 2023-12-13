defmodule EcommerceApi.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EcommerceApiWeb.Telemetry,
      EcommerceApi.Repo,
      {DNSCluster, query: Application.get_env(:ecommerce_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EcommerceApi.PubSub},
      EcommerceApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EcommerceApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    EcommerceApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
