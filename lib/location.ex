defmodule Dbparser.Location do
  import Logger
  alias Dbparser.HttpFetcher

  @location_service_url "https://open-api.bahn.de/bin/rest.exe/location.name?format=json&lang=en&input=<LOCATION>&authKey=<AUTH_KEY>" #Application.get_env(:dbparser, :location_service_url)

  def fetch_station_data(stationname) do
    debug("Fetching station data for #{stationname}")
    {:ok, reg} = Regex.compile("^" <> Regex.escape(stationname))
    HttpFetcher.get(@location_service_url, %{"<LOCATION>" => stationname})
    |> parse_response
    |> Enum.filter(fn %{"name" => name} -> name =~ reg end)
  end

  def parse_response({:ok, data}) do
    %{"LocationList" => %{"StopLocation" => locations}} =
      data
      |> Poison.decode!

    locations
      |> Enum.map(fn loc -> Map.take(loc, ~w(id name)) end)
  end
end
