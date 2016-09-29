defmodule DepartureBoardUi.DepartureBoardReceiver do
  use GenServer
  import Logger
  alias DepartureBoardUi.Repo
  alias DepartureBoardUi.DepartureBoard

  @name {:global, __MODULE__}

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, [], name: @name, debug: [:trace])
  end

  def handle_cast({:departure_board, %{"token" => token, "board" => %{"departures" => departures, "station" => %Dbparser.Station{name: station_name}}}}, state) do
    info("Received departure board for token #{token}")

    # stored_board = Repo.one!(DepartureBoard.by_token(token))
    store_departures(token, station_name, departures)
    {:noreply, state}
  end


  def store_departures(token, station_name, departures) when is_list(departures) do
    departures
    |> Enum.each(fn departure ->
        store_departures(token, station_name, departure)
      end)
  end

  def store_departures(token, station_name, %Dbparser.DepartureBoard{
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
                       time: time} = board) do
    info("Storing #{inspect board}")
    cs = DepartureBoard.changeset(%DepartureBoard{}, %{token: token, name: name, direction: direction, time: time, date: date, station_name: station_name})
    Repo.insert! cs

  end
end
