defmodule DepartureBoardUi.DepartureBoardView do
  use DepartureBoardUi.Web, :view

  def render("show.json", %{departure_board: departure_board}) do
    departure_board
  end
end
