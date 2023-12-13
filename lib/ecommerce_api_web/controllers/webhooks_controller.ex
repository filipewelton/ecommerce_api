defmodule EcommerceApiWeb.WebhooksController do
  use EcommerceApiWeb, :controller

  import EcommerceApi

  alias Plug.Conn
  alias EcommerceApiWeb.FallbackController
  alias EcommerceApi.Support.Error

  action_fallback FallbackController

  @succeeded "payment_intent.succeeded"
  @failed "payment_intent.failed"

  def index(%Conn{} = conn, _params) do
    with {:ok, signature} <- get_signature(conn),
         {:ok, raw_payload} <- get_payload(conn),
         {:ok, payload} <- parse_payload(raw_payload),
         :ok <- validate_signature(raw_payload, signature),
         _ <- handle_update_order(payload) do
      conn
      |> put_status(204)
      |> text("")
    end
  end

  defp get_signature(%Conn{req_headers: headers}) do
    case Enum.find(headers, fn {k, _v} -> k == "stripe-signature" end) do
      nil -> Error.build(400, %{stripe_signature: "is required"})
      {_, signature} -> {:ok, signature}
    end
  end

  defp get_payload(%Conn{} = conn) do
    case Conn.read_body(conn) do
      {:ok, payload, _conn} -> {:ok, payload}
      {_, return, _conn} -> Error.build(500, return)
    end
  end

  defp parse_payload(payload) do
    case Jason.decode(payload) do
      {:error, error} -> Error.build(500, error)
      return -> return
    end
  end

  defp validate_signature(payload, signature) do
    secret = Application.fetch_env!(:ecommerce_api, :stripe_cli_secret)

    case Stripe.Webhook.construct_event(payload, signature, secret) do
      {:ok, _} -> :ok
      {:error, error} -> Error.build(500, error)
    end
  end

  defp handle_update_order(%{"type" => type} = params) when type == @succeeded do
    try do
      order_id =
        Map.get(params, "data")
        |> Map.get("object")
        |> Map.get("metadata")
        |> Map.get("order_id")

      params = %{
        "id" => order_id,
        "order_status" => :confirmed,
        "payment_status" => :paid
      }

      update_order(params)
    rescue
      ArgumentError ->
        Error.build(400, %{order_id: "is required"})
    end
  end

  defp handle_update_order(%{"type" => type} = params) when type == @failed do
    try do
      order_id =
        Map.get(params, "data")
        |> Map.get("object")
        |> Map.get("metadata")
        |> Map.get("order_id")

      params = %{
        "id" => order_id,
        "order_status" => :canceled,
        "payment_status" => :refused
      }

      update_order(params)
    rescue
      ArgumentError ->
        Error.build(400, %{order_id: "is required"})
    end
  end

  defp handle_update_order(_payload) do
    :ok
  end
end
