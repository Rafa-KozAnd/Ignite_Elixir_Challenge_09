defmodule Rockelivery.Users.DeleteTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.UUID
  alias Rockelivery.Users.Delete

  alias Rockelivery.Users.Schemas.User

  describe "call/1" do
    test "sucess, delete user" do
      params = insert(:user)
      response = Delete.call(params.id)

      assert {:ok,
              %User{
                address: "Av. Teste de Changeset",
                age: 36,
                cep: "69905080",
                cpf: "12312312312",
                email: "bruguedes@gmail.com",
                id: _id,
                name: "Bruno Guedes"
              }} = response
    end

    test "fail, delete user" do
      id = UUID.generate()

      response = Delete.call(id)

      assert {:error, %Rockelivery.Error{result: "user not found", status: :not_found}} = response
    end
  end
end
