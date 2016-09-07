defmodule Dbparser.PrinterServer do
  use GenServer
  import Logger
  alias Dbparser.Printer

  @name {:global, Dbparser.PrinterServer}

  def start_link do
    info("Starting #{inspect @name}")
    GenServer.start_link(__MODULE__, [], name: @name, debug: [:trace])
  end

  def print_board(departure_info) do
    GenServer.cast(@name, {:print_departure_board, %{"info" => departure_info}})
  end

  ####

  def handle_cast({:print_departure_board, %{"info" => departure_info}}, _state) do
    Printer.print_board(departure_info)
    {:noreply, _state}
  end
end
