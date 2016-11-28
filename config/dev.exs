use Mix.Config
#config :dbparser, http_fetcher_module: Dbparser.HttpFetcher
config :dbparser, http_fetcher_module: Dbparser.LocalFileHttpFetcher
config :dbparser, http_fetcher_data_location_dir: "apps/dbparser/test/data/"
