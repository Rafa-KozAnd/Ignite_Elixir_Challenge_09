defmodule Rockelivery.Orders.ReportTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.Orders.Report

  describe "report/1" do
    test "sucess, report created" do
      insert(:order)
      assert :ok = Report.create()
    end
  end
end
