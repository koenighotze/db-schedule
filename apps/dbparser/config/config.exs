use Mix.Config
config :dbparser, location_service_url: "https://open-api.bahn.de/bin/rest.exe/location.name?format=json&lang=en&input=<LOCATION>&authKey=<AUTH_KEY>"
config :dbparser, departure_service_url: "https://open-api.bahn.de/bin/rest.exe/departureBoard?format=json&lang=en&authKey=<AUTH_KEY>&id=<STATION_ID>&date=<DATE>&time=<TIME>"
import_config "#{Mix.env}.exs"
