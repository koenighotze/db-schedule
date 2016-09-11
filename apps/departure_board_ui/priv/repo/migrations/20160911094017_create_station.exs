defmodule DepartureBoardUi.Repo.Migrations.CreateStation do
  use Ecto.Migration

  def change do
    create table(:stations) do
      add :name, :string
      add :db_id, :integer

      timestamps
    end

  end
end
