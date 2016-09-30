defmodule DepartureBoardUi.DepartureBoardReceiver do
  @moduledoc """
  This module reacts to incoming departure board data and stores said
  data using the token as an id.

  Note that incoming board data is broadcasted to all listeners.
  """
  use GenServer
  import Logger
  alias DepartureBoardUi.{Repo, DepartureBoard, DepartureBoardChannel, Router, Endpoint}

  @name __MODULE__

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, [], name: @name)
  end


  def handle_cast({:departure_board, %{"token" => token,
                                       "board" => %{"departures" => departures,
                                                    "station"    => %Dbparser.Station{name: station_name}}}},
                  state) do
    info("Received departure board for token #{token}")

    store_departures(token, station_name, departures)
    DepartureBoardChannel.departureboard_ready(Router.Helpers.departure_board_url(Endpoint, :fetch, token), station_name)
    {:noreply, state}
  end

  def handle_cast({:departure_board, %{"token" => token}}, state) do
    warn("Nothing found for #{token}")

    DepartureBoardChannel.departureboard_not_found("Not found")
    {:noreply, state}
  end


  def store_departures(token, station_name, departures) when is_list(departures) do
    departures
    |> Enum.each(fn departure ->
        store_departures(token, station_name, departure)
      end)
  end

  def store_departures(_token, station_name, %Dbparser.DepartureBoard{
                       date: nil,
                       direction: nil,
                       name: nil,
                       time: nil}) do
    debug("Ignore empty board for #{station_name}")
  end

  def store_departures(token, station_name, %Dbparser.DepartureBoard{
                       date: date,
                       direction: direction,
                       name: name,
                       time: time}) do
    cs = DepartureBoard.changeset(%DepartureBoard{}, %{token: token, name: name, direction: direction, time: time, date: date, station_name: station_name})
    Repo.insert! cs
  end
end
