defmodule Rockelivery.Users.Create do
  alias Rockelivery.{Error, Repo}
  alias Rockelivery.Users.Schemas.User

  def call(params) do
    case client().get_cep_info(params["cep"]) do
      {:ok, address} -> create_user(address, params)
      {:error, _result} = error -> error
    end
  end

  defp create_user(address, params) do
    params
    |> Map.put("address", address)
    |> User.changeset_create()
    |> Repo.insert()
    |> handle_insert()
  end

  def handle_insert({:ok, %User{} = user}), do: {:ok, user}

  def handle_insert({:error, result}) do
    {:error, Error.build(:bad_request, result)}
  end

  defp client do
    Application.fetch_env!(:rockelivery, __MODULE__)[:via_cep_adapter]
  end
end
