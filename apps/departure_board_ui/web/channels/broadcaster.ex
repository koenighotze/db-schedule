defmodule DepartureBoardUi.Broadcaster do
  use GenServer

  @name  __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name, debug: [:trace])
  end

  def board_ready(url, station_name) do
    GenServer.cast(@name, {:board_ready, url, station_name})
  end

end
