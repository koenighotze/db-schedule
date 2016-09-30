defmodule DepartureBoardUi.DepartureBoardChannel do
  use DepartureBoardUi.Web, :channel

  import Logger

  def join("departureboards:ready", _params, socket) do
    info("Join from #{inspect socket}")

    # DepartureBoardUi.Broadcaster.new_client(socket)
    {:ok, socket}
  end

  def handle_in("departureboard_ready", url, socket) do
    broadcast! socket, "departureboard_ready", %{url: url}

    {:noreply, socket}
  end

  def departureboard_ready(url, station_name) do
    info("Broadcasting #{url}")

    DepartureBoardUi.Endpoint.broadcast! "departureboards:ready", "departureboard_ready", %{url: url, station_name: station_name}
  end

  def departureboard_not_found(message) do
    DepartureBoardUi.Endpoint.broadcast! "departureboards:ready", "not_found", %{message: message}
  end

end
