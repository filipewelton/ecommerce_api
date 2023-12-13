defmodule EcommerceApiWeb.Plugs.VerifyUUID do
  import Plug.Conn

  alias Plug.Conn

  @allowed_methods ["GET", "DELETE", "UPDATE"]

  def init(default), do: default

  def call(%Conn{} = conn, _default) when conn.method in @allowed_methods do
    %{"id" => id} = conn.params

    case UUID.info(id) do
      {:ok, _} ->
        conn

      {:error, _} ->
        body = Jason.encode!(%{id: "is invalid"})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, body)
        |> halt()
    end
  end

  def call(%Conn{} = conn, _default), do: conn
end
