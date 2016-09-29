defmodule DepartureBoardUi.DepartureBoardSocket do
  use Phoenix.Socket
  import Logger
  ## Channels
  channel "departureboards:*", DepartureBoardUi.DepartureBoardChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket,
    timeout: 45_000

  def connect(_params, socket) do
    info("Connected to #{inspect socket}")
    {:ok, socket}
  end

  def id(_socket), do: nil
end
