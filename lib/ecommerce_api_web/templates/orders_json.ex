defmodule EcommerceApiWeb.OrdersJSON do
  def render("create.json", %{order: order, url: url}) do
    %{
      order: order,
      checkout_url: url
    }
  end

  def render("show.json", %{order: order}) do
    %{order: order}
  end

  def render("update.json", %{order: order}) do
    %{order: order}
  end
end
