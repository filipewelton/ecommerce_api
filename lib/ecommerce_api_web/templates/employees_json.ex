defmodule EcommerceApiWeb.EmployeesJSON do
  def render("sign_up.json", %{user: user, token: token}) do
    %{
      session_token: token,
      user: user
    }
  end

  def render("sign_in.json", %{user: user, token: token}) do
    %{
      session_token: token,
      user: user
    }
  end

  def render("update.json", %{user: user}) do
    %{user: user}
  end
end
