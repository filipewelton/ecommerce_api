defmodule EcommerceApiWeb.ProductsJSON do
  def render("create.json", %{product: product}) do
    %{product: product}
  end

  def render("get.json", %{product: product}) do
    %{product: product}
  end

  def render("update.json", %{product: product}) do
    %{product: product}
  end
end
