defmodule Rockelivery.Orders.ReportRunnerTest do
  use Rockelivery.DataCase, async: true

  use GenServer

  import Rockelivery.Factory

  alias Rockelivery.Orders.ReportRunner

  describe "handle_info/2" do
    test "sucess, report created" do
      insert(:order)

      ReportRunner.init(%{})
      assert {:noreply, _state} = ReportRunner.handle_info(:generate, 1000 * 60)
    end

    test "fail, when params are invalid" do
      GenServer.start_link(ReportRunner, %{})

      assert {:error, "genserver failure"} = ReportRunner.handle_info(:not_valid, 1000 * 60)
    end
  end
end
