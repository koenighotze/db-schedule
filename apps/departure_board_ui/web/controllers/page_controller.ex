defmodule DepartureBoardUi.PageController do
  use DepartureBoardUi.Web, :controller
  import DepartureBoardUi.TimeUtil
  @timezone "Europe/Berlin"

  def index(conn, _params) do
    render conn, "index.html", cities: ~W(Köln Bonn Frankfurt München), current_time: "#{now}", current_date: "#{today}"
  end
end
