defmodule Rockelivery.Users.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.UUID
  alias Rockelivery.Users.Get
  alias Rockelivery.Users.Schemas.User

  describe "by_id/1" do
    test "seccess, when user id exist" do
      params = insert(:user)

      assert {:ok,
              %User{
                address: "Av. Teste de Changeset",
                age: 36,
                cep: "69905080",
                cpf: "12312312312",
                email: "bruguedes@gmail.com",
                id: _id,
                name: "Bruno Guedes"
              }} = Get.by_id(params.id)
    end

    test "fail, when user id params not valid or id not found" do
      assert {:error, %Rockelivery.Error{result: "user not found", status: :not_found}} ==
               Get.by_id(UUID.generate())
    end
  end
end
