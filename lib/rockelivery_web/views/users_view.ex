defmodule RockeliveryWeb.UsersView do
  use RockeliveryWeb, :view

  alias Rockelivery.Users.Schemas.User

  def render("create.json", %{token: token, user: %User{} = user}) do
    %{
      message: "User created!",
      user: user,
      token: token
    }
  end

  def render("sing_in.json", %{token: token}), do: %{token: token}

  def render("user.json", %{user: %User{} = user}), do: %{user: user}
end
