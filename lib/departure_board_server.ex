defmodule Dbparser.DepartureBoardServer do
  use GenServer
  import Logger
  alias Dbparser.{Departure, Location}

  @name {:global, __MODULE__}

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, [], name: @name)#, debug: [:trace] )
  end

  def fetch_departure_board(station_name, date, time) do
    GenServer.call @name, {:departure_board, %{"station_name" => station_name, "date" => date, "time" => time}}
  end

  def fetch_departure_board_async(station_name, date, time) do
    GenServer.call @name, {:departure_board, %{"station_name" => station_name, "date" => date, "time" => time, "reply_to" => self}}
  end

  def handle_call({:departure_board, %{"station_name" => station_name, "date" => date, "time" => time}} = message, _from, state) do
    {:departure_board, payload} = message

    case Map.get(payload, "reply_to") do
      nil -> res = Location.fetch_station_data(station_name)
                   |> Dbparser.fetch_departure_boards(date, time)
            {:reply, res, state}
      sender ->
        %Task{:pid => pid} = Task.async(
          fn ->
            Location.fetch_station_data(station_name)
            |> Dbparser.fetch_departure_boards(date, time)
            |> Enum.each(fn board -> Dbparser.PrinterServer.print_board(board) end)
          end
        )
        {:reply, {:accepted, %{"pid" => pid}}, state}
    end
  end
end
