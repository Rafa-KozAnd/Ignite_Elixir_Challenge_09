defmodule Rockelivery.Users.Schemas.UserTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.Users.Schemas.User

  setup do
    user = build(:user_params)
    {:ok, user: user}
  end

  describe "changeset_create/1" do
    test "sucess, when params are valid", ctx do
      response = User.changeset_create(ctx.user)

      assert %Changeset{
               changes: %{
                 address: "Av. Teste de Changeset",
                 age: 36,
                 cep: "69905080",
                 cpf: "12312312312",
                 email: "bruguedes@gmail.com",
                 name: "Bruno Guedes",
                 password: "123123",
                 password_hash: _
               },
               valid?: true
             } = response
    end

    test "fail, when params are invalid", ctx do
      params = %{ctx.user | "cep" => "123", "cpf" => "456", "email" => "not_valid"}
      response = User.changeset_create(params)

      assert %Changeset{
               changes: %{
                 address: "Av. Teste de Changeset",
                 age: 36,
                 cep: "123",
                 cpf: "456",
                 email: "not_valid",
                 name: "Bruno Guedes",
                 password: "123123"
               },
               errors: [
                 email: {"has invalid format", [validation: :format]},
                 cpf:
                   {"should be %{count} character(s)",
                    [count: 11, validation: :length, kind: :is, type: :string]},
                 cep:
                   {"should be %{count} character(s)",
                    [count: 8, validation: :length, kind: :is, type: :string]}
               ],
               valid?: false
             } = response
    end
  end

  describe "changeset_update/1" do
    test "sucess, when params are valid", ctx do
      params = User.changeset_create(ctx.user)
      update_params = %{"name" => "Bruno Silva", "age" => 46}
      response = User.changeset_update(params, update_params)

      assert %Changeset{
               changes: %{
                 address: "Av. Teste de Changeset",
                 age: 46,
                 cep: "69905080",
                 cpf: "12312312312",
                 email: "bruguedes@gmail.com",
                 name: "Bruno Silva",
                 password: "123123",
                 password_hash: _
               },
               valid?: true
             } = response
    end

    test "fail, when params are invalid", ctx do
      update_params = %{"name" => "Bruno Silva", "age" => 17}

      response =
        ctx.user
        |> User.changeset_create()
        |> User.changeset_update(update_params)

      assert %Changeset{
               changes: %{
                 address: "Av. Teste de Changeset",
                 age: 17,
                 cep: "69905080",
                 cpf: "12312312312",
                 email: "bruguedes@gmail.com",
                 name: "Bruno Silva",
                 password: "123123",
                 password_hash: _
               },
               errors: [
                 age:
                   {"must be greater than or equal to %{number}",
                    [validation: :number, kind: :greater_than_or_equal_to, number: 18]}
               ],
               valid?: false
             } = response
    end
  end

  describe "build/1" do
    test "sucess, when params are valid", ctx do
      response =
        User.changeset_create(ctx.user)
        |> User.build()

      assert {:ok,
              %User{
                address: "Av. Teste de Changeset",
                age: 36,
                cep: "69905080",
                cpf: "12312312312",
                email: "bruguedes@gmail.com",
                name: "Bruno Guedes",
                password: "123123",
                password_hash: _
              }} = response
    end

    test "fail, when params are invalid", ctx do
      params = %{ctx.user | "cep" => "123", "cpf" => "456", "email" => "not_valid"}

      response =
        User.changeset_create(params)
        |> User.build()

      assert {:error,
              %Changeset{
                changes: %{
                  address: "Av. Teste de Changeset",
                  age: 36,
                  cep: "123",
                  cpf: "456",
                  email: "not_valid",
                  name: "Bruno Guedes",
                  password: "123123"
                },
                errors: [
                  email: {"has invalid format", [validation: :format]},
                  cpf:
                    {"should be %{count} character(s)",
                     [count: 11, validation: :length, kind: :is, type: :string]},
                  cep:
                    {"should be %{count} character(s)",
                     [count: 8, validation: :length, kind: :is, type: :string]}
                ],
                valid?: false
              }} = response
    end
  end
end
