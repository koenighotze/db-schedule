defmodule Dbparser do
  alias Dbparser.Location
  alias Dbparser.Departure
  alias Dbparser.Printer

  def fetch_board_sync(stationname) do
    Location.fetch_station_data(stationname)
    |> Enum.map(
       fn %{"id" => station_id} = station_data ->
        %{"station" => station_data, "departures" => Departure.fetch_departure_board(station_id, "2016-09-08", "19:00")}
       end)
    |> Enum.each(&Printer.print_board/1)
  end

  def fetch_board(stationname, date \\ "2016-09-08", time \\ "19:00") do
    Location.fetch_station_data(stationname)
    |> Enum.map(
       fn %{"id" => station_id} = station_data ->
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
