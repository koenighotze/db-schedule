defmodule DepartureBoardUi.PageController do
  use DepartureBoardUi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
