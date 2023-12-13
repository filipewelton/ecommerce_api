defmodule EcommerceApiWeb.WalletsJSON do
  def render("create.json", %{wallet: wallet}), do: %{wallet: wallet}

  def render("show.json", %{wallet: wallet}), do: %{wallet: wallet}
end
