defmodule EcommerceApiWeb.ErrorJSON do
  import Ecto.Changeset

  alias Ecto.Changeset

  def render("error.json", %{error: %Changeset{} = changeset}) do
    %{errors: parse_errors(changeset)}
  end

  def render("error.json", %{error: error}) do
    %{errors: error}
  end

  def render("404.json", _) do
    %{route: "not found"}
  end

  # coveralls-ignore-start

  def render("500.json", errors) do
    content = Kernel.inspect(errors)
    File.write("log", content)

    %{error: "an internal error occurred"}
  end

  # coveralls-ignore-end

  defp parse_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
