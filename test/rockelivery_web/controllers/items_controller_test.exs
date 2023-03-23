defmodule RockeliveryWeb.ItemsControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  alias RockeliveryWeb.Auth.Guardian

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    {:ok, conn: conn, user: user}
  end

  describe "create/1" do
    test "sucess, when all params is valid", ctx do
      item = build(:item_params)

      response =
        ctx.conn
        |> post(Routes.items_path(ctx.conn, :create, item))
        |> json_response(:created)

      assert %{
               "message" => "Item created!",
               "item" => %{
                 "category" => "food",
                 "description" => "Banana 2",
                 "id" => _id,
                 "photo" => "/priv/photos/banaa.jpg",
                 "price" => "10.00"
               }
             } = response
    end

    test "fail, when some parameter is invalid", ctx do
      item = build(:item_params, category: "invalid", description: ":0", price: "0.00")

      response =
        ctx.conn
        |> post(Routes.items_path(ctx.conn, :create, item))
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "category" => ["is invalid"],
                 "description" => ["should be at least 5 character(s)"],
                 "price" => ["must be greater than 0"]
               }
             } = response
    end
  end
end
