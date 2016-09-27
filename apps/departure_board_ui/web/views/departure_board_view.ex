defmodule DepartureBoardUi.DepartureBoardView do
  use DepartureBoardUi.Web, :view
  require Logger

  def render("fetch.json", %{departure_boards: departure_boards}) do
    departure_boards =
      departure_boards
      |> Enum.map(fn board -> Map.drop(board, [:token, :id]) end)

    %{
      "departure_boards" =>
        Phoenix.View.render_many(departure_boards, DepartureBoardUi.DepartureBoardView, "show.json")
    }
  end

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
