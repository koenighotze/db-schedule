defmodule DepartureBoardUi.DepartureBoardController do
  @moduledoc """

  This module controls the actual departureboards.
  It is responsible for triggering the retrieval of the board data
  and depends on the DepartureBoardServer for the hard work.

  The token is used to fetch the board data when it is available

  """
  use DepartureBoardUi.Web, :controller

  alias Dbparser.{DepartureBoardServer}
  alias DepartureBoardUi.{DepartureBoard}

  @doc """
  Fetches the board data via its retrieval token.
  """
  def fetch(conn, %{"token" => token}) do
    boards = Repo.all(DepartureBoard.by_token(token))

    render(conn, departure_boards: boards)
  end

  @doc """
  Drops the departureboard as json.
  """
  def show(conn, %{"station_name" => station_name, "departure_date" => departure_date, "departure_time" => departure_time}) do
    {:accepted, %{"pid" => _pid, "token" => token}} = DepartureBoardServer.fetch_departure_board_async(station_name, departure_date, departure_time, DepartureBoardUi.DepartureBoardReceiver)

    render(conn, board_url: DepartureBoardUi.Router.Helpers.departure_board_url(DepartureBoardUi.Endpoint, :fetch, token))
  end
end
