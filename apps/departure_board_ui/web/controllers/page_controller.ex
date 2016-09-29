defmodule DepartureBoardUi.PageController do
  use DepartureBoardUi.Web, :controller
  @timezone "Europe/Berlin"

  def index(conn, _params) do
    %{:year => year, :month => month, :day => day, :hour => hour, :second => second}
      = Timex.now(@timezone)
      |> Map.take([:year, :month, :day, :hour, :second])

    render conn, "index.html", cities: ~W(Köln Bonn Frankfurt München), current_time: "#{hour}:#{second}", current_date: "#{year}-#{month}-#{day}"
  end
end
