defmodule DepartureBoardUi.DepartureBoardTest do
  use DepartureBoardUi.ModelCase

  alias DepartureBoardUi.DepartureBoard

  @valid_attrs %{date: "some content", direction: "some content", station_name: "some content", time: "some content", token: "123"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DepartureBoard.changeset(%DepartureBoard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DepartureBoard.changeset(%DepartureBoard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
