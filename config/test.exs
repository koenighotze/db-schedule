use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dbparser, Dbparser.Endpoint,
  http: [port: 4001],
  server: false

config :dbparser, http_fetcher_module: Dbparser.LocalFileHttpFetcher
# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dbparser, Dbparser.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dbparser_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
