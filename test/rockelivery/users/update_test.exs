defmodule Rockelivery.Users.UpdateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.Users.Schemas.User
  alias Rockelivery.Users.Update

  describe "call/1" do
    test "seccess, when user id exist" do
      user = insert(:user)
      params = %{"id" => user.id, "address" => "Teste de update user"}
      new_adress = Map.get(params, "address")

      assert {:ok,
              %User{
                address: ^new_adress,
                age: 36,
                cep: "69905080",
                cpf: "12312312312",
                email: "bruguedes@gmail.com",
                id: _id,
                name: "Bruno Guedes"
              }} = Update.call(params)
    end

    test "fail, when user id params not valid or id not found" do
      user = insert(:user)

      params = %{
        "id" => user.id,
        "address" => "Teste de update user",
        "email" => "email_not_valid"
      }

      assert {:error,
              %Rockelivery.Error{
                result: %Ecto.Changeset{
                  action: :update,
                  changes: %{address: "Teste de update user", email: "email_not_valid"},
                  errors: [email: {"has invalid format", [validation: :format]}],
                  data: %Rockelivery.Users.Schemas.User{},
                  valid?: false
                },
                status: :bad_request
              }} = Update.call(params)
    end
  end
end
