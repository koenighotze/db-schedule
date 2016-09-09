ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Dbparser.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Dbparser.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Dbparser.Repo)

