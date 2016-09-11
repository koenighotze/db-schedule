defmodule Timex.Time do
  @moduledoc """
  This module provides helper functions for working with Times
  """

  @doc """
  Converts an hour between 0..24 to {1..12, :am/:pm}

  ## Examples

  iex> Timex.Time.to_12hour_clock(23)
  {11, :pm}

  """
  @spec to_12hour_clock(0..24) :: {1..12, :am | :pm}
  def to_12hour_clock(hour) when hour in 0..24 do
    case hour do
      hour when hour in [0, 24] -> {12, :am}
      hour when hour < 12       -> {hour, :am}
      hour when hour === 12     -> {12, :pm}
      hour when hour > 12       -> {hour - 12, :pm}
    end
  end

  @doc """
  Converts an hour between 1..12 in either am or pm, to value between 0..24

  ## Examples

  iex> Timex.Time.to_24hour_clock(7, :pm)
  19

  """
  @spec to_24hour_clock(1..12, :am | :pm) :: 0..23
  def to_24hour_clock(hour, am_or_pm) when hour in 1..12 and am_or_pm in [:am, :pm] do
    case am_or_pm do
      :am when hour === 12 -> 0
      :am                  -> hour
      :pm when hour === 12 -> hour
      :pm                  -> hour + 12
    end
  end

end
