defmodule Dbparser.DepartureBoardServer do
  use GenServer
  import Logger
  alias Dbparser.Location

  @name {:global, __MODULE__}

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, [], name: @name )#, debug: [:trace] )
  end

  def fetch_departure_board(station_name, date \\ "", time \\ "") do
    GenServer.call @name,
                   {:departure_board, %{"station_name" => station_name, "date" => date, "time" => time}},
                   5000
  end

  def fetch_departure_board_async(station_name, date, time, reply_to) do
    GenServer.call @name, {:departure_board, %{"station_name" => station_name, "date" => date, "time" => time, "reply_to" => reply_to}}
  end

  def handle_call({:departure_board, %{"station_name" => station_name, "date" => date, "time" => time}} = message, _from, state) do
    {:departure_board, payload} = message

    case Map.get(payload, "reply_to") do
      nil -> res = Location.fetch_station_data(station_name)
                   |> Dbparser.fetch_departure_boards(date, time)
            {:reply, res, state}
      reply_to ->
        token = :os.system_time

        %Task{:pid => pid} = Task.async(
          fn ->
            Location.fetch_station_data(station_name)
            |> Dbparser.fetch_departure_boards(date, time)
            |> send_reply(reply_to, token)

            # |> Enum.each(fn board -> Dbparser.PrinterServer.print_board(board) end)
          end
        )

        {:reply, {:accepted, %{"pid" => pid, "token" => token}}, state}
    end
  end

  def send_reply([], reply_to, token) do
    GenServer.cast(reply_to, {:departure_board, %{"token" => token, "board" => [:EMPTY]}})
  end

  def send_reply(board_data, reply_to, token) do
    board_data
    |> Enum.each(fn board -> GenServer.cast(reply_to, {:departure_board, %{"token" => token, "board" => board}}) end)
  end
end
