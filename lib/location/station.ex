defmodule Dbparser.Station do
  @derive [Poison.Encoder]
  defstruct [:id, :name]
end
