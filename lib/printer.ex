defmodule Dbparser.Printer do
  import IO.ANSI

  def print_board(%{"departures" => departures, "station" => %{"name" => station_name}}) do
    IO.puts(underline() <> white() <> "Departure Board for Station " <> yellow() <> "#{station_name}" <> default_color() <> no_underline())
    print_departures(departures)
  end

  def print_departures(%{}), do: IO.puts("Sorry, no departures")

  def print_departures(departures) do
    departures
    |> Enum.sort(fn (%{"date" => dateA, "time" => timeA}, %{"date" => dateB, "time" => timeB}) ->
      if dateA == dateB do
        timeA < timeB
      else
        dateA < dateB
      end
    end)
    |> Enum.each(&print_departure/1)
  end

  def print_departure(%{"date" => date, "direction" => direction, "name" => name, "time" => time, "stops" => stops}) do
    IO.puts(green() <> "#{date} #{time}" <> default_color() <> ": " <> yellow() <> "#{name}" <> default_color() <> " leaves in the direction "<> yellow() <> "#{direction} "<> white() <> "via")
    stops
    |> Enum.each(fn %{"name" => station} = detail ->
      arrTime = Map.get(detail, "arrTime", "-----")
      track = Map.get(detail, "track", "n/a")

      IO.puts("\t"<> green() <>  "#{arrTime} " <> yellow() <> "#{station} " <> default_color() <> " on track " <> blue() <> "#{track}")
    end)
  end

end
