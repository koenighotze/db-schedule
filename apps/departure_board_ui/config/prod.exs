use Mix.Config

config :departure_board_ui, DepartureBoardUi.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "protected-badlands-17194.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json"
  secret_key_base: System.get_env("SECRET_KEY_BASE")


config :departure_board_ui, DepartureBoardUi.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: System.get_env("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true
# Do not print debug messages in production
config :logger, level: :info
