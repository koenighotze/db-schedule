defmodule DepartureBoardUi.PageControllerTest do
  use DepartureBoardUi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello DepartureBoardUi!"
  end
end
