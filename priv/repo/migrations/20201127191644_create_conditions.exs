defmodule Gibon.Repo.Migrations.CreateConditions do
  use Ecto.Migration

  def change do
    create table(:conditions) do
      add :operator, :string
      add :value, :string
      add :url, :string
      add :type, :string
      add :device_id, references(:devices)

      timestamps()
    end
  end
end
