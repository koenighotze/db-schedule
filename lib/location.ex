defmodule Dbparser.Location do
  import Logger
  alias Dbparser.{Station, HttpFetcher}

  @location_service_url "https://open-api.bahn.de/bin/rest.exe/location.name?format=json&lang=en&input=<LOCATION>&authKey=<AUTH_KEY>"

  def fetch_station_data(stationname) do
    debug("Fetching station data for #{stationname}")

    HttpFetcher.get(@location_service_url, %{"<LOCATION>" => stationname})
    |> parse_response
    |> filter_stations(stationname)
  end

  def parse_response({:ok, data}) do
    data
    |> Poison.decode!(as: %{"LocationList" => %{"StopLocation" => [%Station{}]}}) |> get_in(["LocationList", "StopLocation"])
  end

  def filter_stations(stations, stationname) do
    {:ok, reg} = Regex.compile("^" <> Regex.escape(stationname))

    stations
    |> Enum.filter(fn %Station{name: name} -> name =~ reg end)
  end
end
