defmodule EcommerceApi.Customers.Get do
  alias EcommerceApi.Repo
  alias EcommerceApi.Customer
  alias EcommerceApi.Support.Error

  def by_id(id) do
    case Repo.get(Customer, id) do
      %Customer{} = customer -> {:ok, customer}
      nil -> Error.build(404, %{customer: "not found"})
    end
  end

  def by_email(email) when is_bitstring(email) do
    case Repo.get_by(Customer, email: email) do
      %Customer{} = customer -> {:ok, customer}
      nil -> Error.build(404, %{customer: "not found"})
    end
  end
end
