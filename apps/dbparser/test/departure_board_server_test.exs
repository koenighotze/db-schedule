defmodule Dbparser.DepartureBoardServerTest do
  use Dbparser.Case
  alias Dbparser.DepartureBoardServer

  test "fetch_departure_board replies with the departure board" do
      assert [%{"departures" => _data } | _rest] = DepartureBoardServer.fetch_departure_board("Bonn", "2016-09-08", "08:00")
  end

  test "fetch_departure_board with the departure board async" do
      assert {:accepted, %{"pid" => _}} = DepartureBoardServer.fetch_departure_board_async("Bonn", "2016-09-08", "08:00")
  end
end
