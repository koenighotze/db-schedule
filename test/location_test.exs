defmodule Dbparser.LocationTest do
  use ExUnit.Case, async: true
  alias Dbparser.Location
  alias Dbparser.Station

  test "parse_response returns a station" do
    assert [%Station{id: _id, name: _name} | _rest] = Location.parse_response({:ok, Testdata.location_data})
  end

  test "filter_stations removes irrelevant entries" do
    stations = [
      %Station{id: "id", name: "bar"},
      %Station{id: "id", name: "alfonso barista"}
    ]
    assert [
      %Station{id: "id", name: "bar"}
    ] == Location.filter_stations(stations, "bar")

  end
end
