defmodule DepartureBoardUi.SlackView do
  use DepartureBoardUi.Web, :view

  def render("fetch.json", %{token: token}) do
    %{"result" => token}
  end

end
