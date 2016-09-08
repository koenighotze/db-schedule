defmodule Dbparser.JourneyDetail do
  alias Dbparser.{HttpFetcher, JourneyDetails}

  def fetch_journey_detail(url, start_station_name) do
    HttpFetcher.get(url, %{})
    |> parse_response
    |> extract_stops(start_station_name)
  end

  def parse_response({:ok, data}) do
    data
    |> Poison.decode!(as: %{"JourneyDetail" => %{"Stops" => %{ "Stop" => [%JourneyDetails{}]}}})
    |> get_in(~w(JourneyDetail Stops Stop))
  end

  def extract_stops(stops, start_station_name) do
    stops = stops
      |> Enum.sort(fn (%JourneyDetails{routeIdx: a}, %JourneyDetails{routeIdx: b}) -> String.to_integer(a) < String.to_integer(b) end)
      |> Enum.drop_while(fn %JourneyDetails{name: name} -> name != start_station_name end)

    stops
  end
end
