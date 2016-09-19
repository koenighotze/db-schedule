defmodule DepartureBoardUi.Repo.Migrations.CreateDepartureBoard do
  use Ecto.Migration

  def change do
    create table(:departure_boards) do
      add :station_name, :string
      add :time, :string
      add :date, :string
      add :direction, :string

      timestamps
    end

  end
end
