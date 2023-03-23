defmodule Rockelivery.Orders.Test do
  import Ecto.Query

  alias Rockelivery.Orders.Create

  def change do
    teste =
      Enum.reduce(1..500, [], fn x, acc ->
        user =
          Enum.random([
            "8762ed34-59f2-4ce1-95b2-6fda34e192d2",
            "a920affe-40d4-4d0b-818d-c72ac7307457"
          ])

        item1 =
          Enum.random([
            "b6140a75-2214-4900-b9ac-9cb363e92a61",
            "90953432-2121-4ac4-824b-b2a361ec7e5f"
          ])

        item2 =
          Enum.random([
            "b6140a75-2214-4900-b9ac-9cb363e92a61",
            "90953432-2121-4ac4-824b-b2a361ec7e5f"
          ])

        comments = Enum.random(["com açucar", "com mel", "com sal", "com pimenta"])
        payment_method = Enum.random(["money", "credit_card", "debit_card"])
        quantity = Enum.random(1..3)

        [
          %{
            "address" => "Minha casa #{x}",
            "comments" => comments,
            "items" => [
              %{"id" => item1, "quantity" => quantity},
              %{"id" => item2, "quantity" => quantity}
            ],
            "payment_method" => payment_method,
            "user_id" => user
          }
          | acc
        ]
      end)

    teste
    |> Enum.map(fn params ->
      Create.call(params)
    end)
  end
end
