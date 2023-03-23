defmodule RockeliveryWeb.OrdersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  alias Ecto.UUID

  alias RockeliveryWeb.Auth.Guardian

  setup %{conn: conn} do
    user = insert(:user, cpf: "00000000000", email: "authorization@mail.com")
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn, user: user}
  end

  describe "create/1" do
    test "sucess, when all params is valid", ctx do
      order = build(:order_params)

      response =
        ctx.conn
        |> post("/api/orders", order)
        |> json_response(:created)

      assert %{
               "message" => "Order created!",
               "order" => %{
                 "address" => "Av. Teste de Changeset",
                 "comments" => "Com Pimenta",
                 "id" => _id,
                 "items" => [
                   %{
                     "category" => "food",
                     "description" => "Banana 2",
                     "id" => _,
                     "photo" => "/priv/photos/banaa.jpg",
                     "price" => "10.00"
                   },
                   %{
                     "category" => "food",
                     "description" => "Banana 2",
                     "id" => _,
                     "photo" => "/priv/photos/banaa.jpg",
                     "price" => "10.00"
                   },
                   %{
                     "category" => "food",
                     "description" => "Banana 2",
                     "id" => _,
                     "photo" => "/priv/photos/banaa.jpg",
                     "price" => "10.00"
                   },
                   %{
                     "category" => "food",
                     "description" => "Banana 2",
                     "id" => _,
                     "photo" => "/priv/photos/banaa.jpg",
                     "price" => "10.00"
                   }
                 ],
                 "payment_method" => "credit_card",
                 "user_id" => _user_id
               }
             } = response
    end

    test "fail, when some parameter is invalid", ctx do
      item = insert(:item)

      param = %{
        "address" => ctx.user.address,
        "user_id" => ctx.user.id,
        "comments" => ":X",
        "payment_method" => "invalid",
        "items" => [
          %{"id" => item.id, "quantity" => 2}
        ]
      }

      response =
        ctx.conn
        |> post("/api/orders", param)
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "comments" => ["should be at least 6 character(s)"],
                 "payment_method" => ["is invalid"]
               }
             } = response
    end

    test "fail, when id item is invalid", ctx do
      id_item_invalid = UUID.generate()
      insert(:item)

      param = %{
        "address" => ctx.user.address,
        "user_id" => ctx.user.id,
        "comments" => "Com Pimenta",
        "payment_method" => "credit_card",
        "items" => [
          %{"id" => id_item_invalid, "quantity" => 2}
        ]
      }

      response =
        ctx.conn
        |> post("/api/orders", param)
        |> json_response(:bad_request)

      assert %{"message" => "Invalid ids!"} = response
    end
  end
end
