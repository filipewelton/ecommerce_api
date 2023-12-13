defmodule EcommerceApi.Support.Error do
  @keys [:status, :error]
  @enforce_keys @keys

  defstruct @keys

  def build(status, error) do
    %__MODULE__{
      status: status,
      error: error
    }
  end
end
