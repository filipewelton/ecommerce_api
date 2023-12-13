defmodule EcommerceApiWeb.OrdersController do
  use EcommerceApiWeb, :controller

  import EcommerceApi

  alias EcommerceApiWeb.FallbackController
  alias EcommerceApiWeb.Plugs.AuthorizeSession

  plug AuthorizeSession, ["orders:create"] when action == :create
  plug AuthorizeSession, ["orders:get"] when action == :show
  plug AuthorizeSession, ["orders:update"] when action == :update

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, order, url} <- create_order(params) do
      conn
      |> put_status(201)
      |> render("create.json", order: order, url: url)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, order} <- get_order(id) do
      conn
      |> put_status(200)
      |> render("show.json", order: order)
    end
  end

  def update(conn, params) do
    with {:ok, order} <- update_order(params) do
      conn
      |> put_status(200)
      |> render("update.json", order: order)
    end
  end
end
