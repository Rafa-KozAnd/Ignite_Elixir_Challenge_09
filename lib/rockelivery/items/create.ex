defmodule Rockelivery.Items.Create do
  alias Rockelivery.{Error, Repo}
  alias Rockelivery.Items.Schemas.Item

  def call(params) do
    params
    |> Item.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  def handle_insert({:ok, %Item{}} = result), do: result

  def handle_insert({:error, result}) do
    {:error, Error.build(:bad_request, result)}
  end
end
