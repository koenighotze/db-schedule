defmodule DepartureBoardUi.DepartureBoardController do
  use DepartureBoardUi.Web, :controller

  def show(conn, %{"station_name" => station_name, "departure_date" => departure_date, "departure_time" => departure_time}) do
    # TODO: how to protect against timeouts?
    board = Dbparser.DepartureBoardServer.fetch_departure_board(station_name, departure_date, departure_time)

    render(conn, departure_board: board)
  end
end
