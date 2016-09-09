defmodule Dbparser.PrinterTest do
  use Dbparser.Case

  test "print_departure prints a departure", %{departures: departures} do
    assert capture_io(fn ->
      departures
      |> List.first
      |> Printer.print_departure
    end) != ""
  end

  test "the departure board gets printed", %{departure_board: board} do
    assert capture_io(fn ->
      Printer.print_board(board)
    end) |> String.contains?("bar")
  end

end
