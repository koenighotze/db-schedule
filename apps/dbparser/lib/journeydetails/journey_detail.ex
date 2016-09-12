defmodule Dbparser.JourneyDetail do
  import Logger
  alias Dbparser.JourneyDetails

  @http_fetcher_module Application.get_env(:dbparser, :http_fetcher_module)

  def fetch_journey_detail(url, start_station_name) do
    @http_fetcher_module.get(url, %{})
    |> parse_response
    |> extract_stops(start_station_name)
  end

  def parse_response({:ok, data}) do
    data
    |> Poison.decode!(as: %{"JourneyDetail" => %{"Stops" => %{ "Stop" => [%JourneyDetails{}]}}})
    |> get_in(~w(JourneyDetail Stops Stop))
  end

  def parse_response({:error, reason}) do
    warn("Cannot fetch Journey Details due to #{reason}")
    []
  end

  def extract_stops(nil, _start_station_name) do
    []
  end

  def extract_stops(stops, start_station_name) do
    stops
      |> Enum.sort(fn (%JourneyDetails{routeIdx: a}, %JourneyDetails{routeIdx: b}) -> String.to_integer(a) < String.to_integer(b) end)
      |> Enum.drop_while(fn %JourneyDetails{name: name} -> name != start_station_name end)
  end
end
