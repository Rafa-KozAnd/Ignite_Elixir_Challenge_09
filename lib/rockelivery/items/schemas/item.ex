defmodule Rockelivery.Items.Schemas.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rockelivery.Orders.Schemas.Order

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:category, :description, :price, :photo]

  @category [:food, :drink, :desert]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "items" do
    field :category, Ecto.Enum, values: @category
    field :description, :string
    field :price, :decimal
    field :photo, :string

    many_to_many :orders, Order, join_through: "orders_items"

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:description, min: 5)
    |> validate_number(:price, greater_than: 0)
    |> validate_inclusion(:category, @category)
  end
end
