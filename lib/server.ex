defmodule Service do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__, debug: [:trace])
  end

  def handle_call(message, {pid, _ref}, state) do
    IO.puts("Received message from #{inspect pid}")

    :timer.sleep 1000

    {:reply, {:ok, message}, state}
  end

end
