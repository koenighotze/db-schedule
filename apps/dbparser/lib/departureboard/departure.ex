defmodule Dbparser.Departure do
  alias Dbparser.{HttpFetcher, JourneyDetail, DepartureBoard, JourneyDetails}
  import Logger
  # instead of doing it like this, we'd better move the fetcher to a worker
  # and use it via messages
  @http_fetcher_module Application.get_env(:dbparser, :http_fetcher_module)
  @departure_service_url "https://open-api.bahn.de/bin/rest.exe/departureBoard?format=json&lang=en&authKey=<AUTH_KEY>&id=<STATION_ID>&date=<DATE>&time=<TIME>"

  def fetch_departure_board(station_id, date, time) do
    debug("Fetching departure board for station #{station_id}")
    @http_fetcher_module.get(@departure_service_url, %{"<STATION_ID>" => station_id, "<DATE>" => date, "<TIME>" => time})
    |> parse_response
    |> extract_departures
  end

  def parse_response({:ok, data}) do
    data
    |> Poison.decode!(as: %{"DepartureBoard" => %{"Departure" => [%DepartureBoard{}]}})
    |> get_in(["DepartureBoard", "Departure"])
  end

  def parse_response({:error, reason}) do
    warn("Cannot fetch departure boards due to #{reason}")
    []
  end

  def extract_departures(departures, journey_detail_resolver \\ &JourneyDetail.fetch_journey_detail/2)

  def extract_departures(departures, journey_detail_resolver) when is_list(departures) do
    departures
      |> Enum.take(5)
      |> Enum.map(&( resolve_journey_details(&1, journey_detail_resolver) ))
  end

  # todo Errorcase cleanup
  def extract_departures(%{"DepartureBoard" => %{"errorCode" => code, "errorText" => text}}, _journey_detail_resolver) do
    warn("#{code} #{text}")
    []
  end

  def extract_departures(departure, journey_detail_resolver) do
    departure
    |> resolve_journey_details(journey_detail_resolver)
  end

  def resolve_journey_details(nil, _journey_detail_resolver) do
    %DepartureBoard{}
  end

  def resolve_journey_details(%DepartureBoard{stop: stop, JourneyDetailRef: %{"ref" => url}} = departure_board, journey_detail_resolver) do
      %DepartureBoard{departure_board | JourneyDetailRef: journey_detail_resolver.(url, stop)}
  end

end
