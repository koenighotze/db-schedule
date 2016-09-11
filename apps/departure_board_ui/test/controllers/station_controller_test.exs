defmodule DepartureBoardUi.StationControllerTest do
  use DepartureBoardUi.ConnCase

  alias DepartureBoardUi.Station
  @valid_attrs %{db_id: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, station_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    station = Repo.insert! %Station{}
    conn = get conn, station_path(conn, :show, station)
    assert json_response(conn, 200)["data"] == %{"id" => station.id,
      "name" => station.name,
      "db_id" => station.db_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, station_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, station_path(conn, :create), station: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Station, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, station_path(conn, :create), station: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    station = Repo.insert! %Station{}
    conn = put conn, station_path(conn, :update, station), station: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Station, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    station = Repo.insert! %Station{}
    conn = put conn, station_path(conn, :update, station), station: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    station = Repo.insert! %Station{}
    conn = delete conn, station_path(conn, :delete, station)
    assert response(conn, 204)
    refute Repo.get(Station, station.id)
  end
end
