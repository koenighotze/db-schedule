defmodule DepartureBoardUi.StationTest do
  use DepartureBoardUi.ModelCase

  alias DepartureBoardUi.Station

  @valid_attrs %{db_id: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Station.changeset(%Station{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Station.changeset(%Station{}, @invalid_attrs)
    refute changeset.valid?
  end
end
