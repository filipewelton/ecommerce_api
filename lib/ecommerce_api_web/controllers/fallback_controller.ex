defmodule EcommerceApiWeb.FallbackController do
  use EcommerceApiWeb, :controller

  alias EcommerceApiWeb.ErrorJSON
  alias EcommerceApi.Support.Error

  def call(conn, %Error{status: status, error: error}) do
    conn
    |> put_status(status)
    |> put_view(ErrorJSON)
    |> render("error.json", error: error)
  end
end
