defmodule EcommerceApiWeb.CustomersController do
  use EcommerceApiWeb, :controller

  import EcommerceApi

  alias EcommerceApiWeb.FallbackController
  alias EcommerceApiWeb.Plugs.AuthorizeSession

  plug AuthorizeSession, ["account:delete"] when action in [:delete]
  plug AuthorizeSession, ["account:update"] when action in [:update]

  action_fallback FallbackController

  def sign_up(conn, params) do
    with {:ok, customer} <- create_customer(params) do
      claims = %{
        "email" => customer.email,
        "id" => customer.id
      }

      {:ok, token} = create_customer_token(:customer, claims)

      conn
      |> put_status(201)
      |> render("sign_up.json", customer: customer, token: token)
    end
  end

  def sign_in(conn, params) do
    %{"email" => email, "password" => password} = params

    with {:ok, customer} <- get_customer_by_email(email),
         :ok <- validate_password(customer.password_hash, password) do
      claims = %{
        "email" => customer.email,
        "id" => customer.id
      }

      {:ok, token} = create_customer_token(:customer, claims)

      conn
      |> put_status(200)
      |> render("sign_in.json", customer: customer, token: token)
    end
  end

  def update(conn, params) do
    with {:ok, customer} <- update_customer(params) do
      conn
      |> put_status(200)
      |> render("update.json", customer: customer)
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- delete_customer(id) do
      conn
      |> put_status(204)
      |> text("")
    end
  end
end
