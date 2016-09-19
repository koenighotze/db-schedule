defmodule DepartureBoardUi.DepartureBoardView do
  use DepartureBoardUi.Web, :view
  require Logger
  def render("fetch.json", %{departure_board: departure_board}) do
    departure_board
  end

  def render("show.json", %{departure_board: departure_board}) do
    departure_board
  end

  def render("show.json", %{board_url: url}) do
    %{board_url: url}
  end
end
