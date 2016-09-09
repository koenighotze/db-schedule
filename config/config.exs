# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# https://open-api.bahn.de/bin/rest.exe/location.name?format=json&lang=en&input=Bonn&authKey=DBhackFrankfurt0316

config :dbparser, location_service_url: "https://open-api.bahn.de/bin/rest.exe/location.name?format=json&lang=en&input=<LOCATION>&authKey=<AUTH_KEY>"
config :dbparser, departure_service_url: "https://open-api.bahn.de/bin/rest.exe/departureBoard?format=json&lang=en&authKey=<AUTH_KEY>&id=<STATION_ID>&date=<DATE>&time=<TIME>"
# config :dbparser, http_fetcher_module: Dbparser.HttpFetcher

# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :dbparser, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:dbparser, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

import_config "#{Mix.env}.exs"
