defmodule Rockelivery.ViaCep.Behaviour do
  alias Rockelivery.Error

  @callback get_cep_info(String.t()) :: {:ok, String.t()} | {:error, Error}
end
