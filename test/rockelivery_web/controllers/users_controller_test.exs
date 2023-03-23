defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Ecto.UUID

  alias Rockelivery.ViaCep.ClientMock

  alias RockeliveryWeb.Auth.Guardian

  describe "create/1" do
    test "sucess, when all params is valid", %{conn: conn} do
      user = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, user))
        |> json_response(:created)

      assert %{
               "message" => "User created!",
               "token" => _token,
               "user" => %{
                 "address" => "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC",
                 "age" => 36,
                 "cep" => "69905080",
                 "cpf" => "12312312312",
                 "email" => "bruguedes@gmail.com",
                 "id" => _id,
                 "name" => "Bruno Guedes"
               }
             } = response
    end

    test "fail, when some parameter is invalid", %{conn: conn} do
      user = %{
        "age" => 15,
        "cep" => "69905080",
        "cpf" => "1212",
        "email" => "bruguedesgmail.com",
        "password" => "12",
        "name" => "Bruno Guedes"
      }

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, user))
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "age" => ["must be greater than or equal to 18"],
                 "cpf" => ["should be 11 character(s)"],
                 "email" => ["has invalid format"],
                 "password" => ["should be at least 6 character(s)"]
               }
             } = response
    end

    test "fail, when `cep` not found", %{conn: conn} do
      user = build(:user_params, cep: "00000000")

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:error, %Rockelivery.Error{result: "CEP not found!", status: :not_found}}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, user))
        |> json_response(:not_found)

      assert %{"message" => "CEP not found!"} = response
    end

    test "fail, when user is already registered", %{conn: conn} do
      insert(:user)
      user = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, user))
        |> json_response(:bad_request)

      assert %{"message" => %{"cpf" => ["has already been taken"]}} = response
    end
  end

  describe "update/1" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, user: user}
    end

    test "sucess, when params is valid", ctx do
      params = %{"age" => 37, "email" => "update_email@email.com"}
      user_id = ctx.user.id

      response =
        ctx.conn
        |> put(Routes.users_path(ctx.conn, :update, ctx.user.id), params)
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "address" => "Av. Teste de Changeset",
                 "age" => 37,
                 "cep" => "69905080",
                 "cpf" => "12312312312",
                 "email" => "update_email@email.com",
                 "id" => ^user_id,
                 "name" => "Bruno Guedes"
               }
             } = response
    end

    test "fail, when some parameter is invalid", ctx do
      params = %{
        "age" => 15,
        "email" => "bruguedesgmail.com",
        "name" => "Bruno Guedes"
      }

      response =
        ctx.conn
        |> put(Routes.users_path(ctx.conn, :update, ctx.user.id), params)
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "age" => ["must be greater than or equal to 18"],
                 "email" => ["has invalid format"]
               }
             } = response
    end

    test "fail, when user not found", ctx do
      id_invalid = UUID.generate()

      params = %{
        "name" => "User not update"
      }

      response =
        ctx.conn
        |> put(Routes.users_path(ctx.conn, :update, id_invalid), params)
        |> json_response(:not_found)

      assert %{"message" => "user not found"} = response
    end
  end

  describe "show/1" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn, user: user}
    end

    test "sucess, when id is valid", ctx do
      user_id = ctx.user.id

      response =
        ctx.conn
        |> get(Routes.users_path(ctx.conn, :update, user_id))
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "address" => "Av. Teste de Changeset",
                 "age" => 36,
                 "cep" => "69905080",
                 "cpf" => "12312312312",
                 "email" => "bruguedes@gmail.com",
                 "id" => ^user_id,
                 "name" => "Bruno Guedes"
               }
             } = response
    end

    test "fail, when user not found", ctx do
      id_invalid = UUID.generate()

      response =
        ctx.conn
        |> get(Routes.users_path(ctx.conn, :update, id_invalid))
        |> json_response(:not_found)

      assert %{"message" => "user not found"} = response
    end
  end

  describe "delete/1" do
    test "sucess, when id a valid", %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, user.id))
        |> response(:no_content)

      assert response == ""
    end

    test "fail, when user a not found", %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      id = UUID.generate()

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:not_found)

      assert %{
               "message" => "user not found"
             } = response
    end
  end

  describe "sing_in/1" do
    test "sucess, when id and password is valid", %{conn: conn} do
      user = insert(:user)
      params = %{"id" => user.id, "password" => user.password}

      response =
        conn
        |> post("/api/users/singin", params)
        |> json_response(:ok)

      assert %{"token" => _token} = response
    end

    test "fail, when password not a valid", %{conn: conn} do
      user = insert(:user)
      params = %{"id" => user.id, "password" => "invalid"}

      response =
        conn
        |> post("/api/users/singin", params)
        |> json_response(:unauthorized)

      assert %{"message" => "Please verify your credentials"} = response
    end

    test "fail, when user id not found", %{conn: conn} do
      params = %{"id" => UUID.generate(), "password" => "123123"}

      response =
        conn
        |> post("/api/users/singin", params)
        |> json_response(:not_found)

      assert %{"message" => "user not found"} = response
    end

    test "fail, when user id not a valid", %{conn: conn} do
      params = %{"id" => "invalid", "password" => "123123"}

      response =
        conn
        |> post("/api/users/singin", params)
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end

    test "fail, when params empty", %{conn: conn} do
      response =
        conn
        |> post("/api/users/singin", %{})
        |> json_response(:bad_request)

      assert %{"message" => "Invalid or missing params"} = response
    end
  end
end
