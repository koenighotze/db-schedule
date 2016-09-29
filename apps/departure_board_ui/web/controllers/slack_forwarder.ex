defmodule DepartureBoardUi.SlackForwarder do
  use GenServer
  import Logger
  alias DepartureBoardUi.{Repo,DepartureBoard,DepartureBoardChannel}
  alias DepartureBoardUi.Router.Helpers

  @name __MODULE__

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, %{}, name: @name, debug: [:trace])
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

    %{response_url: response_url, created: created_millis} = Map.get(state, token)
    forward_departures(token, response_url, station_name, departures)

    {:noreply, cleanup(state, token)}
  end

  def cleanup(state, token) do
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

  def forward_departures(token, url, station_name, %Dbparser.DepartureBoard{
                       date: nil,
                       direction: nil,
                       name: nil,
                       time: nil}) do
      debug("Ignore empty board for #{station_name}")
   end


  def forward_departures(token, url, station_name, %Dbparser.DepartureBoard{
                       date: date,
                       direction: direction,
                       name: name,
                       time: time} = board) do

     info("Forwarding to #{url}")

      case HTTPoison.post(url,
                    {:form, [
                      response_type: "in_channel",
                      text: "Train #{name} leaves from #{station_name} with destination #{direction} at #{time}"
                      #, attachments => []
                      ]},
                      %{"Content-type" => "application/json"}) do

        {:ok, response} -> :ok
        {:error, reason} -> warn(reason)
      end
  end
end
