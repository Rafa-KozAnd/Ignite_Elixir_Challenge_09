defmodule Rockelivery do
  @moduledoc """
  Rockelivery keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Orders.Create, as: OrderCreate
  alias Rockelivery.Users.Create, as: CreateUser
  alias Rockelivery.Users.Delete, as: DeleteUser
  alias Rockelivery.Users.Get, as: GetUser
  alias Rockelivery.Users.Update, as: UpdateUser

  defdelegate create_item(params), to: ItemCreate, as: :call
  defdelegate create_order(params), to: OrderCreate, as: :call
  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate delete_user(params), to: DeleteUser, as: :call
  defdelegate get_user_by_id(params), to: GetUser, as: :by_id
  defdelegate update_user(params), to: UpdateUser, as: :call
end
