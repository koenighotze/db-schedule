defmodule DepartureBoardUi.PrettyJson do
  def encode_to_iodata!(data) do
    Poison.encode_to_iodata!(data, pretty: true)
  end
end
