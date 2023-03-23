defmodule Rockelivery.Items.Schemas.ItemTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Decimal
  alias Ecto.Changeset
  alias Rockelivery.Items.Schemas.Item

  setup do
    item = build(:item_params)
    {:ok, item: item}
  end

  describe "changeset/1" do
    test "sucess, when params are valid", ctx do
      response = Item.changeset(ctx.item)
      price = Decimal.new("10.00")

      assert %Changeset{
               changes: %{
                 category: :food,
                 description: "Banana 2",
                 photo: "/priv/photos/banaa.jpg",
                 price: ^price
               },
               valid?: true
             } = response
    end

    test "fail, when params are invalid", ctx do
      params = %{ctx.item | "category" => "invalid_category", "price" => "0"}
      price = Decimal.new("0")
      response = Item.changeset(params)

      assert %Changeset{
               changes: %{
                 description: "Banana 2",
                 photo: "/priv/photos/banaa.jpg",
                 price: ^price
               },
               errors: [
                 price:
                   {"must be greater than %{number}",
                    [validation: :number, kind: :greater_than, number: ^price]},
                 category:
                   {"is invalid",
                    [
                      type:
                        {:parameterized, Ecto.Enum,
                         %{
                           on_dump: %{desert: "desert", drink: "drink", food: "food"},
                           on_load: %{"desert" => :desert, "drink" => :drink, "food" => :food},
                           type: :string,
                           embed_as: :self,
                           mappings: [food: "food", drink: "drink", desert: "desert"],
                           on_cast: %{"desert" => :desert, "drink" => :drink, "food" => :food}
                         }},
                      validation: :cast
                    ]}
               ],
               valid?: false
             } = response
    end
  end
end
