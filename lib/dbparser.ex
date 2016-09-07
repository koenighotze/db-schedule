defmodule Dbparser do
  alias Dbparser.{Location, Departure, Printer, Station}

  @timezone "Europe/Berlin"

  def fetch_board_sync(stationname) do
    Location.fetch_station_data(stationname)
    |> Enum.map(
       fn %Station{id: station_id} = station ->
        %{"station" => station, "departures" => Departure.fetch_departure_board(station_id, "2016-09-08", "19:00")}
       end)
    |> Enum.each(&Printer.print_board/1)
  end

  def fetch_board(stationname) do
    %{:year => year, :month => month, :day => day, :hour => hour, :second => second}
      = Timex.now(@timezone)
      |> Map.take([:year, :month, :day, :hour, :second])

    stationname
      |> fetch_board("#{year}-#{month}-#{day}", "#{hour}:#{second}")
  end

  def fetch_board_message(stationname, date, time) do
  end

  def fetch_board(stationname, date, time) do
    Location.fetch_station_data(stationname)
    |> Enum.map(
       fn %Station{id: station_id} = station_data ->
         Task.async(
          fn ->
            %{"station" => station_data,
              "departures" => Departure.fetch_departure_board(station_id, date, time)}
          end
         )
       end)
    |> Enum.map(&Task.await/1)
    |> Enum.each(&Printer.print_board/1)
  end

  end
