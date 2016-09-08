ExUnit.start()

defmodule Testdata do
  def location_data do
    File.read! "test/data/location.json" |> String.replace("\n", " ")
  end

  def departure_data do
    File.read! "test/data/departure.json" |> String.replace("\n", " ")
  end

  def journey_details_data do
    File.read! "test/data/journey_details.json" |> String.replace("\n", " ")
  end
end
