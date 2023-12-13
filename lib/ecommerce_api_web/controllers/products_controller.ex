defmodule EcommerceApiWeb.ProductsController do
  use EcommerceApiWeb, :controller

  import EcommerceApi

  alias EcommerceApiWeb.FallbackController
  alias EcommerceApiWeb.Plugs.AuthorizeSession

  plug AuthorizeSession, ["stock:create"] when action == :create
  plug AuthorizeSession, ["stock:get"] when action == :show
  plug AuthorizeSession, ["stock:update"] when action == :update

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, product} <- create_product(params) do
      conn
      |> put_status(201)
      |> render("create.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, product} <- get_product(id) do
      conn
      |> put_status(200)
      |> render("get.json", product: product)
    end
  end

  def update(conn, params) do
    with {:ok, product} <- update_product(params) do
      conn
      |> put_status(200)
      |> render("update.json", product: product)
    end
  end
end
