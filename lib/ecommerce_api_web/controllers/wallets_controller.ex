defmodule EcommerceApiWeb.WalletsController do
  use EcommerceApiWeb, :controller

  import EcommerceApi

  alias EcommerceApiWeb.FallbackController
  alias EcommerceApiWeb.Plugs.AuthorizeSession

  plug AuthorizeSession, ["wallets:create"] when action == :create
  plug AuthorizeSession, ["wallets:get"] when action == :show
  plug AuthorizeSession, ["wallets:delete"] when action == :update

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, wallet} <- create_wallet(params) do
      conn
      |> put_status(201)
      |> render("create.json", wallet: wallet)
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- delete_wallet(id) do
      conn
      |> put_status(204)
      |> text("")
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, wallet} <- get_wallet(id) do
      conn
      |> put_status(200)
      |> render("show.json", wallet: wallet)
    end
  end
end
