defmodule EcommerceApiWeb.Plugs.AuthorizeSession do
  import Plug.Conn

  alias EcommerceApi.Support.{TokenHandler, Error}
  alias Plug.Conn

  def init(default), do: default

  def call(%Conn{} = conn, audiences) when conn.method in ["POST", "PATCH"] do
    %{body_params: params} = conn

    with {:ok, token} <- get_session_token(params),
         :ok <- TokenHandler.validate_token(token, audiences) do
      conn
    else
      %Error{status: status, error: error} ->
        response = Jason.encode!(error)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(status, response)
        |> halt()
    end
  end

  def call(%Conn{} = conn, audiences) when conn.method in ["DELETE", "GET"] do
    %{params: params} = conn

    with {:ok, token} <- get_session_token(params),
         :ok <- TokenHandler.validate_token(token, audiences) do
      conn
    else
      %Error{status: status, error: error} ->
        response = Jason.encode!(error)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(status, response)
        |> halt()
    end
  end

  defp get_session_token(%{"session_token" => token}) when is_bitstring(token) do
    {:ok, token}
  end

  defp get_session_token(_), do: Error.build(400, %{session_token: "is required"})
end
