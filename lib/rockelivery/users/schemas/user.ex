defmodule Rockelivery.Users.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Rockelivery.Orders.Schemas.Order

  @email_regex ~r/^[A-Za-z0-9\._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:address, :age, :cep, :cpf, :email, :password, :name]

  @update_params @required_params -- [:password]

  @derive {Jason.Encoder, only: [:id, :name, :email, :age, :cpf, :address, :cep]}

  schema "users" do
    field :address, :string
    field :age, :integer
    field :cep, :string
    field :cpf, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string

    has_many :orders, Order

    timestamps()
  end

  def changeset_create(params) do
    params
    |> changeset(@required_params)
  end

  def changeset_update(struct, params) do
    changeset(struct, params, @update_params)
  end

  def build(changeset), do: apply_action(changeset, :create)

  defp changeset(struct \\ %__MODULE__{}, params, fields) do
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_length(:password, min: 6)
    |> validate_length(:cep, is: 8)
    |> validate_length(:cpf, is: 11)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, @email_regex)
    |> unique_constraint([:email])
    |> unique_constraint([:cpf])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
