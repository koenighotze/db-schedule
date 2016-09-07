defmodule Dbparser.StationTest do
  use ExUnit.Case

  alias Dbparser.Station

  describe "With a given JSON result" do
    test "stations can be read using Poison" do
      Testdata.location_data
      |> Poison.decode!(as: %{"LocationList" => %{"StopLocation" => [%Station{}]}}) |> get_in(["LocationList", "StopLocation"])
    end
  end

end
