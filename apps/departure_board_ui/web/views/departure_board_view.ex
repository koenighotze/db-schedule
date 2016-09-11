defmodule DepartureBoardUi.DepartureBoardView do
  use DepartureBoardUi.Web, :view

  def render("show.json", %{departure_board: departure_board}) do
    %{data: render_one(departure_board, DepartureBoardUi.DepartureBoardView, "departure_board.json")}
  end
end
