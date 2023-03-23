# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rockelivery.Repo.insert!(%Rockelivery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rockelivery.Repo
alias Rockelivery.Items.Schemas.Item
alias Rockelivery.Orders.Schemas.Order
alias Rockelivery.Users.Schemas.User

user = %User{
  age: 36,
  cep: "69900000",
  cpf: "11100022233",
  email: "seeds_test2@gmail.com",
  name: "Bruno Guedes",
  password: "111222"
}

%User{id: user_id} = Repo.insert!(user)

item_1 = %Item{
  category: :food,
  description: "Churrasco",
  price: Decimal.new("10.00"),
  photo: "/priv/photos/churrasco.jpg"
}

item_2 = %Item{
  category: :food,
  description: "Medalhão ",
  price: Decimal.new("15.00"),
  photo: "/priv/photos/medalhao.jpg"
}

Repo.insert!(item_1)
Repo.insert!(item_2)

order = %Order{
  user_id: user_id,
  items: [item_1, item_1, item_2],
  address: "Avenida Epaminondas Jacome. 1977",
  comments: "Molho de pimenta extra",
  payment_method: :money
}

Repo.insert!(order)
