defmodule DepartureBoardUi.DepartureBoardController do
  use DepartureBoardUi.Web, :controller

  alias Dbparser.{DepartureBoardServer}
  alias DepartureBoardUi.{DepartureBoard}

  def fetch(conn, %{"token" => token}) do
    boards = Repo.all(DepartureBoard.by_token(token))

    render(conn, departure_boards: boards)
  end

  def show(conn, %{"station_name" => station_name, "departure_date" => departure_date, "departure_time" => departure_time}) do
    # TODO: how to protect against timeouts?
    {:accepted, %{"pid" => pid, "token" => token}} = DepartureBoardServer.fetch_departure_board_async(station_name, departure_date, departure_time, {:global, DepartureBoardUi.DepartureBoardReceiver})

    render(conn, board_url: DepartureBoardUi.Router.Helpers.departure_board_url(DepartureBoardUi.Endpoint, :fetch, token))
  end
end
