defmodule Rockelivery.Error do
  @keys [:status, :result]
  @enforce_keys @keys

  defstruct @keys

  def build(status, result) do
    %__MODULE__{
      status: status,
      result: result
    }
  end

  def error_changeset(result), do: build(:bad_request, result)
  def error_user_not_found, do: build(:not_found, "user not found")
end
