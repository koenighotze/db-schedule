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

    departures
    |> Enum.each(fn %Dbparser.DepartureBoard{
                         date: date,
                         direction: direction,
                         name: name,
                         time: time} ->
      cs = DepartureBoard.changeset(%DepartureBoard{}, %{token: token, name: name, direction: direction, time: time, date: date, station_name: station_name})
      Repo.insert! cs
    end)
    {:noreply, state}
  end
end
