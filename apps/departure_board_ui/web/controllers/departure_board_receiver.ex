defmodule DepartureBoardUi.DepartureBoardReceiver do
  use GenServer
  import Logger
  alias DepartureBoardUi.Repo

  @name {:global, __MODULE__}

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, [], name: @name, debug: [:trace])
  end

  def handle_cast({:departure_board, %{"token" => token, "board" => board}}, state) do
    info("Received departure board for token #{token}")
    {:noreply, state}
  end
end
