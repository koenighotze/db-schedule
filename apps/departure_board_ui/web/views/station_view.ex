defmodule DepartureBoardUi.StationView do
  use DepartureBoardUi.Web, :view

  def render("index.json", %{stations: stations}) do
    %{data: render_many(stations, DepartureBoardUi.StationView, "station.json")}
  end

  def render("show.json", %{station: station}) do
    %{data: render_one(station, DepartureBoardUi.StationView, "station.json")}
  end

  def render("station.json", %{station: station}) do
    %{id: station.id,
      name: station.name,
      db_id: station.db_id}
  end
end
