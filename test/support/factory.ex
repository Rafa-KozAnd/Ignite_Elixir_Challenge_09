defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  import Mox

  alias Ecto.UUID
  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Items.Schemas.Item
  alias Rockelivery.Orders.Schemas.Order
  alias Rockelivery.Users.Create, as: UserCreate
  alias Rockelivery.Users.Schemas.User
  alias Rockelivery.ViaCep.ClientMock

  def user_params_factory do
    %{
      "address" => "Av. Teste de Changeset",
      "age" => 36,
      "cep" => "69905080",
      "cpf" => "12312312312",
      "email" => "bruguedes@gmail.com",
      "password" => "123123",
      "name" => "Bruno Guedes"
    }
  end

  def user_factory do
    %User{
      id: UUID.generate(),
      address: "Av. Teste de Changeset",
      age: 36,
      cep: "69905080",
      cpf: "12312312312",
      email: "bruguedes@gmail.com",
      password: "123123",
      password_hash: add_hash(),
      name: "Bruno Guedes"
    }
  end

  def create_user_factory do
    expect(ClientMock, :get_cep_info, fn _cep ->
      {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
    end)

    params = build(:user_params)
    {:ok, user} = UserCreate.call(params)
    user
  end

  def item_params_factory do
    %{
      "category" => "food",
      "description" => "Banana 2",
      "price" => "10.00",
      "photo" => "/priv/photos/banaa.jpg"
    }
  end

  def item_factory do
    %Item{
      category: "food",
      description: "Banana 2",
      price: "10.00",
      photo: "/priv/photos/banaa.jpg"
    }
  end

  def create_item_factory do
    params = build(:item_params)
    {:ok, item} = ItemCreate.call(params)
    item
  end

  def order_params_factory do
    user = insert(:user)
    item_1 = insert(:item)
    item_2 = insert(:item)

    %{
      "address" => user.address,
      "user_id" => user.id,
      "comments" => "Com Pimenta",
      "payment_method" => "credit_card",
      "items" => [
        %{"id" => item_1.id, "quantity" => 2},
        %{"id" => item_2.id, "quantity" => 2}
      ]
    }
  end

  def order_factory do
    user = insert(:user)
    item_1 = insert(:item)
    item_2 = insert(:item)

    %Order{
      address: user.address,
      user_id: user.id,
      comments: "Com Pimenta",
      payment_method: "credit_card",
      items: [
        item_1,
        item_2
      ]
    }
  end

  def add_hash do
    %{password_hash: hash} = Pbkdf2.add_hash("123123")
    hash
  end
end
