defmodule Rockelivery.Users.Get do
  alias Rockelivery.{Error, Repo}
  alias Rockelivery.Users.Schemas.User

  def by_id(id) do
    case Repo.get(User, id) do
      %User{} = user -> {:ok, user}
      nil -> {:error, Error.error_user_not_found()}
    end
  end
end
