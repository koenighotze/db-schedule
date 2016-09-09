defmodule Dbparser.LocalFileHttpFetcher do
  import Logger

  @location_service_url "https://open-api.bahn.de/bin/rest.exe/location.name?format=json&lang=en&input=<LOCATION>&authKey=<AUTH_KEY>"
  @departure_service_url "https://open-api.bahn.de/bin/rest.exe/departureBoard?format=json&lang=en&authKey=<AUTH_KEY>&id=<STATION_ID>&date=<DATE>&time=<TIME>"

  def get(url, _params) do
    info("Loading #{url} in mock mode")

    content = case url do
      @location_service_url -> location_data
      @departure_service_url -> departure_data
      _ -> journey_details_data
    end

    {:ok, content}
  end

  def location_data do
    File.read! "test/data/location.json" |> String.replace("\n", " ")
  end

  def departure_data do
    File.read! "test/data/departure.json" |> String.replace("\n", " ")
  end

  def journey_details_data do
    File.read! "test/data/journey_details.json" |> String.replace("\n", " ")
  end
end
