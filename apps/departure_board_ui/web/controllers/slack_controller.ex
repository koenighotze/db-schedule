defmodule DepartureBoardUi.SlackController do
  @moduledoc """
  Interacts with a team slack.

  The supported command is
  /railinfo From <stationname> departure <HH:ss>

  This will fetch the departure boards and return them to Slack
  asynchronously.
  """

  use DepartureBoardUi.Web, :controller
  import DepartureBoardUi.TimeUtil
  alias DepartureBoardUi.SlackForwarder
  alias Dbparser.DepartureBoardServer

  # @token "UBtZ22XP5JISvgkhQqi9065Z"
  @token System.get_env("SLACK_TOKEN") || raise "SLACK_TOKEN not set!"
  def fetch(conn, %{
                    "token" => @token,
                    "command" => "/railinfo",
                    "text" => text,
                    "response_url" => response_url
                  }) do

    captures = ~r/^[Ff]rom (?<station>.*) departure (?<departure_time>(\d?\d:\d\d)|now)/
      |> Regex.named_captures(text)

    handle_request(conn, response_url, captures)
  end

  def handle_request(conn, _response_url, nil), do: render(conn, result: "Invalid request. Use From stations_name departure 19:01")

  def handle_request(conn, response_url, captures) do
    %{"departure_time" => departure_time, "station" => station_name} =
        captures
        |> Map.take(~W(departure_time station))

    departure_time = departure_time |> purge_time

    {:accepted, %{"token" => board_retrieve_token}} =
      DepartureBoardServer.fetch_departure_board_async(station_name, today, departure_time, DepartureBoardUi.SlackForwarder)
    SlackForwarder.register(board_retrieve_token, response_url)

    render(conn, result: "Got it! Searching for departure boards from #{station_name}, departure time #{departure_time} today...")
  end

  def purge_time("now"), do: now

  def purge_time(time), do: time
end
