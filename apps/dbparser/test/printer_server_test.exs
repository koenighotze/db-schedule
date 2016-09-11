defmodule Dbparser.PrinterServerTest do
  use Dbparser.Case
  alias Dbparser.PrinterServer

  test "printer server prints the departure board to stdout", %{departure_board: board} do
    out = capture_io(fn ->
      PrinterServer.print_board(board)
    end)
  end

end
