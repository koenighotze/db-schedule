defmodule DepartureBoardUi.SlackView do
  use DepartureBoardUi.Web, :view

  def render("fetch.json", %{result: result}) do
    result
  end
end
