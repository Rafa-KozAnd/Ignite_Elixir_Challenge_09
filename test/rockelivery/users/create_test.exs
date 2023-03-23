defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.Error
  alias Rockelivery.Users.Create
  alias Rockelivery.Users.Schemas.User
  alias Rockelivery.ViaCep.ClientMock

  describe "call/1" do
    test "sucess, create user" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminondas Jácome, Habitasa, Rio Branco/AC"}
      end)

      response = Create.call(params)

      assert {:ok,
              %User{
                address: "Avenida Epaminondas Jácome, Habitasa, Rio Branco/AC",
                age: 36,
                cep: "69905080",
                cpf: "12312312312",
                email: "bruguedes@gmail.com",
                id: _,
                name: "Bruno Guedes"
              }} = response
    end

    test "fail, create user params invalid" do
      params = build(:user_params, %{"age" => 17, "password" => "123", "email" => "teste.com.br"})

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      response = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        email: ["has invalid format"],
        password: ["should be at least 6 character(s)"]
      }

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == expected_response
    end

    test "fail, when cep number not valid" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:error, %Rockelivery.Error{result: :econnrefused, status: :bad_request}}
      end)

      response = Create.call(params)

      assert {:error, %Rockelivery.Error{result: :econnrefused, status: :bad_request}} = response
    end
  end
end
