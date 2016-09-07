defmodule Dbparser.DepartureBoard do
  @derive [Poison.Encoder]
  defstruct [:time, :date, :direction, :name, :JourneyDetailRef, :stop]
end
