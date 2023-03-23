defmodule Rockelivery.Users.Update do
  alias Rockelivery.{Error, Repo}
  alias Rockelivery.Users.Schemas.User

  def call(%{"id" => id} = params) do
    with %User{} = user <- Repo.get(User, id),
         {:ok, %User{} = user} <- do_update(user, params) do
      {:ok, user}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, Error.error_changeset(changeset)}

      nil ->
        {:error, Error.error_user_not_found()}
    end
  end

  defp do_update(user, params) do
    user
    |> User.changeset_update(params)
    |> Repo.update()
  end
end
