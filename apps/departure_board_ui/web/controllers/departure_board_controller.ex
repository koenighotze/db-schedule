defmodule DepartureBoardUi.DepartureBoardController do
  use DepartureBoardUi.Web, :controller

  alias Dbparser.{DepartureBoardServer}
  alias DepartureBoardUi.{DepartureBoard}

  def fetch(conn, %{"token" => token}) do
    board = Repo.one!(DepartureBoard.by_token(token))

    render(conn, departure_board: board)
    # case Repo.one(DepartureBoard.by_token(token)) do
    #   nil -> conn
    #   |> render(%{"departure_board" => "not_found"})
    #         # conn
    #         # |> put_status(:not_found)
    #         # |> render(DepartureBoardUi.ErrorView, "404.json")
    #   board ->
    #         conn
    #         |> render(%{"departure_board" => board})
    # end
  end

  def show(conn, %{"station_name" => station_name, "departure_date" => departure_date, "departure_time" => departure_time}) do
    # TODO: how to protect against timeouts?
    {:accepted, %{"pid" => pid, "token" => token}} = DepartureBoardServer.fetch_departure_board_async(station_name, departure_date, departure_time, {:global, DepartureBoardUi.DepartureBoardReceiver})

    DepartureBoard.changeset(
        %DepartureBoardUi.DepartureBoard{},
        %{
          token: "#{token}",
          station_name: station_name,
          time: "",
          date: "",
          direction: ""
        })
    |> Repo.insert!

    # todo return url
    render(conn, board_url: DepartureBoardUi.Router.Helpers.departure_board_url(DepartureBoardUi.Endpoint, :fetch, token))
  end
end
