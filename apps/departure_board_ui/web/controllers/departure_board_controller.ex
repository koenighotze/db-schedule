defmodule DepartureBoardUi.DepartureBoardController do
  use DepartureBoardUi.Web, :controller

  alias Dbparser.{DepartureBoardServer, DepartureBoard}

  def show(conn, %{"station_name" => station_name, "departure_date" => departure_date, "departure_time" => departure_time}) do
    # TODO: how to protect against timeouts?
    {:accepted, %{"pid" => pid, "token" => token}} = DepartureBoardServer.fetch_departure_board_async(station_name, departure_date, departure_time, {:global, DepartureBoardUi.DepartureBoardReceiver})

    render(conn, departure_board: %DepartureBoard{})
  end
end
