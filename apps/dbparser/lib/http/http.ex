defmodule Dbparser.Http do
  @callback get(url :: String.t, params :: map() ) :: String.t
end
