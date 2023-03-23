defmodule Rockelivery.Orders.Schemas.OrderTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset

  alias Rockelivery.Orders.Schemas.Order

  setup do
    order = build(:order_params)

    %{"items" => [%{"id" => items_id1}, %{"id" => items_id2}]} = order

    items = [%{id: items_id1}, %{id: items_id2}]

    {:ok, order: order, items: items}
  end

  describe "changeset/1" do
    test "sucess, when params are valid", ctx do
      assert assert %Changeset{
                      changes: %{
                        address: "Av. Teste de Changeset",
                        comments: "Com Pimenta",
                        items: [
                          %Changeset{
                            changes: %{id: _},
                            valid?: true
                          },
                          %Changeset{
                            changes: %{id: _},
                            valid?: true
                          }
                        ],
                        payment_method: :credit_card,
                        user_id: _
                      },
                      valid?: true
                    } = Order.changeset(ctx.order, ctx.items)
    end

    test "fail, when params are invalid", ctx do
      params = %{ctx.order | "comments" => ":0", "payment_method" => "invalid"}
      response = Order.changeset(params, ctx.items)

      assert %Ecto.Changeset{
               changes: %{
                 address: "Av. Teste de Changeset",
                 comments: ":0",
                 items: [
                   %Ecto.Changeset{
                     valid?: true
                   },
                   %Ecto.Changeset{
                     valid?: true
                   }
                 ],
                 user_id: _
               },
               errors: [
                 comments:
                   {"should be at least %{count} character(s)",
                    [count: 6, validation: :length, kind: :min, type: :string]},
                 payment_method:
                   {"is invalid",
                    [
                      type:
                        {:parameterized, Ecto.Enum,
                         %{
                           embed_as: :self,
                           mappings: [
                             money: "money",
                             credit_card: "credit_card",
                             debit_card: "debit_card"
                           ],
                           on_cast: %{
                             "credit_card" => :credit_card,
                             "debit_card" => :debit_card,
                             "money" => :money
                           },
                           on_dump: %{
                             credit_card: "credit_card",
                             debit_card: "debit_card",
                             money: "money"
                           },
                           on_load: %{
                             "credit_card" => :credit_card,
                             "debit_card" => :debit_card,
                             "money" => :money
                           },
                           type: :string
                         }},
                      validation: :cast
                    ]}
               ],
               valid?: false
             } = response
    end
  end
end
