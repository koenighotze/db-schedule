defmodule Dbparser.Departure do
  alias Dbparser.{HttpFetcher, JourneyDetail, DepartureBoard}
  import Logger

  @departure_service_url "https://open-api.bahn.de/bin/rest.exe/departureBoard?format=json&lang=en&authKey=<AUTH_KEY>&id=<STATION_ID>&date=<DATE>&time=<TIME>"

  def fetch_departure_board(station_id, date, time) do
    debug("Fetching departure board for station #{station_id}")
    HttpFetcher.get(@departure_service_url, %{"<STATION_ID>" => station_id, "<DATE>" => date, "<TIME>" => time})
    |> parse_response
    |> extract_departures
  end

  def parse_response({:ok, data}) do
    data
    |> Poison.decode!(as: %{"DepartureBoard" => %{"Departure" => [%DepartureBoard{}]}})
    |> get_in(["DepartureBoard", "Departure"])
  end

  def parse_response({:error, reason}) do
    raise "FIX ME"
  end

  def extract_departures(departures, journey_detail_resolver \\ &JourneyDetail.fetch_journey_detail/2)

  def extract_departures(departures, journey_detail_resolver) when is_list(departures) do
    departures
      |> Enum.take(5)
      |> Enum.map(fn %DepartureBoard{stop: stop, JourneyDetailRef: %{"ref" => url}} = dep ->
        Map.merge(dep, journey_detail_resolver.(url, stop))
      end)
  end

  # todo Errorcase cleanup
  def extract_departures(%{"DepartureBoard" => %{"errorCode" => code, "errorText" => text}}, _journey_detail_resolver) do
    warn("#{code} #{text}")
    #%{}
    raise
  end

  def extract_departures(departure, _journey_detail_resolver) do
      extract_fields(departure)
  end
end
