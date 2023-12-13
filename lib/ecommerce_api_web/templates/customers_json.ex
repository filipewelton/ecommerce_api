defmodule EcommerceApiWeb.CustomersJSON do
  def render("sign_up.json", %{customer: customer, token: token}) do
    %{
      session_token: token,
      customer: customer
    }
  end

  def render("sign_in.json", %{customer: customer, token: token}) do
    %{
      session_token: token,
      customer: customer
    }
  end

  def render("update.json", %{customer: customer}) do
    %{customer: customer}
  end
end
