defmodule Dbparser.Case do
  use ExUnit.CaseTemplate
  alias Dbparser.{Printer, JourneyDetails, Station, DepartureBoard}

  using do
    quote do
      use ExUnit.Case, async: false
      import ExUnit.CaptureIO
      alias Dbparser.{Printer, JourneyDetails, Station, DepartureBoard}
    end
  end

  setup do
    board = %{"station" => %Station{id: "id", name: "bar"},
              "departures" => [%DepartureBoard{time: "time", date: "date", direction: "direction", name: "name", JourneyDetailRef: [%JourneyDetails{}], stop: "stop"}]}
    {:ok, departure_board: board, departures: board["departures"]}
  end
end
