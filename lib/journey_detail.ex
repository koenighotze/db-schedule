defmodule Dbparser.JourneyDetail do
  alias Dbparser.HttpFetcher

  def fetch_journey_detail(url, start_station_name) do
    HttpFetcher.get(url, %{})
    |> parse_response(start_station_name)
  end

  def parse_response({:ok, data}, start_station_name) do
    data
      |> Poison.decode!
      |> extract_stops(start_station_name)
  end

  def extract_stops(%{"JourneyDetail" => %{"Stops" => %{ "Stop" => stops}}}, start_station_name) do
    stops = stops
      |> Enum.map(fn loc -> Map.take(loc, ~w(name arrTime track routeIdx)) end)
      |> Enum.sort(fn (%{"routeIdx" => a}, %{"routeIdx" => b}) -> String.to_integer(a) < String.to_integer(b) end)
      |> Enum.drop_while(fn %{"name" => name} -> name != start_station_name end)

    %{"stops" => stops}
  end

  def extract_stops(_, _start_station_name) do
    %{"stops" => []}
  end
end
