defmodule Dbparser.JourneyDetailTest do
  use ExUnit.Case, async: true

  alias Dbparser.{JourneyDetail, JourneyDetails}

  test "parse_response returns the journey details" do
    [%JourneyDetails{name: _, arrTime: _, track: _, routeIdx: _} | _rest] = JourneyDetail.parse_response({:ok, Testdata.journey_details_data})
  end

  test "extract_stops drops all before stations name" do
    data = JourneyDetail.parse_response({:ok, Testdata.journey_details_data})
    assert [%JourneyDetails{name: "Bonn Hbf", arrTime: "18:42", track: "1", routeIdx: "14"} | _rest] = JourneyDetail.extract_stops(data, "Bonn Hbf")
  end
end
