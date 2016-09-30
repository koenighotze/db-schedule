defmodule DepartureBoardUi.TimeUtil do
  @timezone "Europe/Berlin"

  def today do
    %{:year => year, :month => month, :day => day} =
        Timex.now(@timezone)
        |> Map.take([:year, :month, :day])

    "#{year}-#{month}-#{day}"
  end

  def now do
    %{:hour => hour, :second => second} =
        Timex.now(@timezone)
        |> Map.take([:hour, :second])

    "#{hour}:#{second}"
  end
end
