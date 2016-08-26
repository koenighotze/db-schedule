defmodule Dbparser.Departure do
  use GenServer

  alias Dbparser.HttpFetcher
  alias Dbparser.JourneyDetail
  import Logger

  @name __MODULE__
  # todo move authKey to HttpFetcher
  @departure_service_url "https://open-api.bahn.de/bin/rest.exe/departureBoard?format=json&lang=en&authKey=<AUTH_KEY>&id=<STATION_ID>&date=<DATE>&time=<TIME>"

  def start_server do
    GenServer.start_link(@name, [], [ name: @name, debug: [:trace, :statistics] ])
  end

  def fetch_departure_board_async(station_id, date, time) do
    GenServer.call @name, {:departure_board, %{"station_id" => station_id, "date" => date, "time" => time}}
  end

  ###########################

  def handle_call({:departure_board, %{"station_id" => station_id, "date" => date, "time" => time}}, _from, state) do
    {:reply, fetch_departure_board(station_id, date, time), state}
  end

  def fetch_departure_board(station_id, date, time) do
    debug("Fetching departure board for station #{station_id}")
    HttpFetcher.get(@departure_service_url, %{"<STATION_ID>" => station_id, "<DATE>" => date, "<TIME>" => time})
    |> parse_response
  end

  def parse_response({:ok, data}) do
    data
    |> Poison.decode!
    |> extract_departures
  end

  def extract_departures(%{"DepartureBoard" => %{"Departure" => departures}}) when is_list(departures) do
    departures
      |> Enum.take(5)
      |> Enum.map(&extract_fields/1)
      |> Enum.map(fn %{"stop" => stop, "JourneyDetailRef" => %{"ref" => url}} = dep ->
        Map.merge(dep, JourneyDetail.fetch_journey_detail(url, stop))
      end)
  end

  def extract_departures(%{"DepartureBoard" => %{"Departure" => departure}}) do
      extract_fields(departure)
  end

  def extract_departures(%{"DepartureBoard" => %{"errorCode" => code, "errorText" => text}}) do
    warn("#{code} #{text}")
    %{}
  end

  defp extract_fields(departure) do
    Map.take(departure, ~w(time date direction name JourneyDetailRef stop))
  end
end
