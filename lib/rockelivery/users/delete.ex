defmodule Rockelivery.Users.Delete do
  alias Rockelivery.{Error, Repo}
  alias Rockelivery.Users.Schemas.User

  def call(id) do
    case Repo.get(User, id) do
      %User{} = user -> Repo.delete(user)
      nil -> {:error, Error.error_user_not_found()}
    end
  end
end
