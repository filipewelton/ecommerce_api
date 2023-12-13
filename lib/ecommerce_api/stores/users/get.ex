defmodule EcommerceApi.Stores.Users.Get do
  alias EcommerceApi.Repo
  alias EcommerceApi.Stores.User
  alias EcommerceApi.Support.Error

  def by_id(id) do
    case Repo.get(User, id) do
      %User{} = user -> cast_assoc(user)
      nil -> Error.build(404, %{user: "not found"})
    end
  end

  def by_email(:employee, email) when is_bitstring(email) do
    with %User{} = user <- Repo.get_by(User, email: email),
         true <- user.role == :employee do
      {:ok, user}
    else
      _ -> Error.build(404, %{user: "not found"})
    end
  end

  def by_email(:manager, email) when is_bitstring(email) do
    with %User{} = user <- Repo.get_by(User, email: email),
         true <- user.role == :manager do
      {:ok, user}
    else
      _ -> Error.build(404, %{user: "not found"})
    end
  end

  def by_email(_, _), do: Error.build(400, %{email: "must be of type string"})

  defp cast_assoc(user) do
    {:ok, user}
  end
end
