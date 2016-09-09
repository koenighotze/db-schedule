defmodule Dbparser.JourneyDetails do
  @derive [Poison.Encoder]
  defstruct [:name, :arrTime, :track, :routeIdx]
end
