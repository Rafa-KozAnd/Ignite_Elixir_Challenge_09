defmodule Rockelivery.Orders.TotalPrice do
  alias Rockelivery.Items.Schemas.Item

  def calculate(items) do
    Enum.reduce(items, Decimal.new("0.00"), &sum_price(&1, &2))
  end

  defp sum_price(%Item{price: price}, acc), do: Decimal.add(price, acc)
end
