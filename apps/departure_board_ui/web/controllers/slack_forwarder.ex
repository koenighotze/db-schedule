defmodule DepartureBoardUi.SlackForwarder do
  @moduledoc """
  Forwards search results to Slack.
  """
  use GenServer
  import Logger

  @name __MODULE__

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def register(token, response_url) do
    GenServer.call(@name, {:register, %{token: token, response_url: response_url}})
  end

  def handle_call({:register, %{token: token, response_url: response_url}}, _from, state) do
    info("Registering #{response_url} for token #{token}")
    {:reply, :ok, Map.put(state, "#{token}", %{response_url: response_url, created: :os.system_time(:milli_seconds)})}
  end

  def handle_cast({:departure_board, %{"token" => token, "board" => %{"departures" => departures, "station" => %Dbparser.Station{name: station_name}}}}, state) do
    info("Received departure board for token #{token}")

    %{response_url: response_url} = Map.get(state, token)
    forward_departures(token, response_url, station_name, departures)

    {:noreply, remove_old_listeners(state, token)}
  end

  def remove_old_listeners(state, token) do
    %{created: created_millis} = Map.get(state, token)

    if :os.system_time(:milli_seconds) - created_millis > 5000 do
      Map.delete(state, token)
    else
      state
    end
  end

  def forward_departures(token, response_url, station_name, departures) when is_list(departures) do
    departures
    |> Enum.each(fn departure ->
        forward_departures(token, response_url, station_name, departure)
      end)
  end

  def forward_departures(_token, _url, station_name, %Dbparser.DepartureBoard{
                       date: nil,
                       direction: nil,
                       name: nil,
                       time: nil}) do
      debug("Ignore empty board for #{station_name}")
   end


  def forward_departures(_token, url, station_name, %Dbparser.DepartureBoard{
                       date: _date,
                       direction: direction,
                       name: name,
                       time: time}) do
    info("Forwarding to #{url}")

    payload = %{
      response_type: "in_channel",
      text: "Train #{name} leaves from #{station_name} with destination #{direction} at #{time}"
    }

    data = payload |> Poison.encode!
    debug("Sending #{data}")
    case HTTPoison.post(url, data, %{"content-type" => "application/json"}) do
      {:ok, response} -> info("Successfully forwarded. #{inspect response}")
      {:error, reason} -> warn(reason)
    end
  end
end
