use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :departure_board_ui, DepartureBoardUi.Endpoint,
  http: [port: 4001],
  server: false

config :departure_board_ui,
  slack_token: "foo"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :departure_board_ui, DepartureBoardUi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "departure_board_ui_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
