ExUnit.start

Mix.Task.run "ecto.create", ~w(-r DepartureBoardUi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r DepartureBoardUi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(DepartureBoardUi.Repo)

