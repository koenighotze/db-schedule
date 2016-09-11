defmodule DepartureBoardUi.DepartureBoardController do
  use DepartureBoardUi.Web, :controller

  def show(conn, %{"station_name" => station_name, "departure_date" => departure_date, "departure_time" => departure_time}) do
    render(conn, "show.json", departure_board: %Dbparser.DepartureBoard{})
  end
end
