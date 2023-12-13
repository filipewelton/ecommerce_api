defmodule Test.JSONParse do
  def call(json) do
    with {:ok, encoded} <- Jason.encode(json),
         {:ok, decoded} <- Jason.decode(encoded) do
      decoded
    end
  end
end
