defmodule EcommerceApiWeb.EmployeesController do
  use EcommerceApiWeb, :controller

  import EcommerceApi

  alias EcommerceApiWeb.FallbackController
  alias EcommerceApiWeb.Plugs.AuthorizeSession

  plug AuthorizeSession, ["account:delete"] when action == :delete
  plug AuthorizeSession, ["account:update"] when action == :update

  action_fallback FallbackController

  def sign_up(conn, params) do
    payload = Map.put(params, "role", :employee)

    with {:ok, user} <- create_store_user(payload) do
      claims = %{
        "email" => user.email,
        "id" => user.id
      }

      {:ok, token} = create_user_token(:employee, claims)

      conn
      |> put_status(201)
      |> render("sign_up.json", user: user, token: token)
    end
  end

  def sign_in(conn, params) do
    %{"email" => email, "password" => password} = params

    with {:ok, user} <- get_store_user_by_email(:employee, email),
         :ok <- validate_password(user.password_hash, password) do
      claims = %{
        "email" => user.email,
        "id" => user.id
      }

      {:ok, token} = create_user_token(:employee, claims)

      conn
      |> put_status(200)
      |> render("sign_in.json", user: user, token: token)
    end
  end

  def update(conn, params) do
    with {:ok, user} <- update_store_user(params) do
      conn
      |> put_status(200)
      |> render("update.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- delete_store_user(id) do
      conn
      |> put_status(204)
      |> text("")
    end
  end
end
