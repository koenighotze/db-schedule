defmodule DepartureBoardUi.SlackController do
  use DepartureBoardUi.Web, :controller

  alias DepartureBoardUi.SlackForwarder
  alias Dbparser.DepartureBoardServer
  # token=XXTFHorsJbuSsngOmwqOXh69
  # team_id=T0001
  # team_domain=example
  # channel_id=C2147483705
  # channel_name=test
  # user_id=U2147483697
  # user_name=Steve
  # command=/weather
  # text=94070
  # response_url=https://hooks.slack.com/commands/1234/5678
  @timezone "Europe/Berlin"
  @token "UBtZ22XP5JISvgkhQqi9065Z"

  def fetch(conn, %{
      "token" => @token,
      "command" => "/railinfo",
      "text" => text,
      "response_url" => response_url
    }) do

    %{"departure_time" => departure_time, "station" => station_name} =
        ~r/^[Ff]rom (?<station>.*) departure (?<departure_time>(\d\d:\d\d)|now)/
        |> Regex.named_captures(text)
        |> Map.take(~W(departure_time station))

    departure_time = departure_time |> purge_time

    {:accepted, %{"pid" => _pid, "token" => board_retrieve_token}} =
      DepartureBoardServer.fetch_departure_board_async(station_name, today, departure_time, DepartureBoardUi.SlackForwarder)
    SlackForwarder.register(board_retrieve_token, response_url)

    render(conn, token: "Got it...searching...")
  end

  def fetch(conn, params) do
    render(conn, token: params)
  end

  def today do
    %{:year => year, :month => month, :day => day} =
        Timex.now(@timezone)
        |> Map.take([:year, :month, :day])

    "#{year}-#{month}-#{day}"
  end

  def now do
    %{:hour => hour, :second => second} =
        Timex.now(@timezone)
        |> Map.take([:hour, :second])

    "#{hour}:#{second}"
  end

  def purge_time("now"), do: now

  def purge_time(time), do: time
end
