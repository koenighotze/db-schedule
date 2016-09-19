defmodule DepartureBoardUi.Repo.Migrations.AddTokenId do
  use Ecto.Migration

  def change do
    alter table(:departure_boards) do
      add :token, :string
    end
  end
end
