use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :dbparser, Dbparser.Endpoint,
  secret_key_base: "7imUnBkNT4RmL0K5zWFbCIw9nm+nf+d4h1MyqhX7vivM1DrAr8gTWNziQ7c9S1Ho"

# Configure your database
config :dbparser, Dbparser.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dbparser_prod",
  pool_size: 20
