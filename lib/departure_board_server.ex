defmodule Dbparser.DepartureBoardServer do
  use GenServer
  import Logger
  alias Dbparser.Departure

  @name {:global, __MODULE__}

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, [], name: @name, debug: [:trace, :statistics] )
  end

  def fetch_departure_board(station_id, date, time) do
    GenServer.call @name, {:departure_board, %{"station_id" => station_id, "date" => date, "time" => time}}
  end

  def fetch_departure_board_async(station_id, date, time) do
    GenServer.call @name, {:departure_board, %{"station_id" => station_id, "date" => date, "time" => time, "reply_to" => self}}
  end

  ###########################

  def handle_call({:departure_board, %{"station_id" => station_id, "date" => date, "time" => time}} = message, _from, state) do
    {:departure_board, payload} = message

    case Map.get(payload, "reply_to") do
      nil -> {:reply, %{"station" => %{"name" => "station_name"},
                        "departures" => Departure.fetch_departure_board(station_id, date, time)}, state}
      sender ->
        %Task{:pid => pid} = Task.async(
          fn ->
            %{"station" => %{"name" => "station_name"},
              "departures" => Departure.fetch_departure_board(station_id, date, time)}
            |> Dbparser.PrinterServer.print_board
            debug("Finished")
          end
        )
        {:reply, {:accepted, %{"pid" => pid}}, state}
    end
  end
end
