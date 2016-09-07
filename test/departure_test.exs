defmodule Dbparser.DepartureTest do
  use ExUnit.Case

  alias Dbparser.{Departure, DepartureBoard}

  test "parse_response returns a list of Departures" do
    assert [%DepartureBoard{time: _, date: _, direction: _, name: _, JourneyDetailRef: _, stop: _} | _rest] = Departure.parse_response({:ok, Testdata.departure_data})
  end

  test "extract_departures returns the 5 first first departures" do
    res =
      {:ok, Testdata.departure_data}
      |> Departure.parse_response
      |> Departure.extract_departures(fn (url, _stop) -> %{url: url} end)

    assert 5 == length(res)

    res
      |> Enum.each(fn board -> assert board.url != "" end)
  end

  test "errors result in an empty map" do
    # TODO implement me
  end

end
