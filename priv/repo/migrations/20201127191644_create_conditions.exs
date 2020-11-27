defmodule Gibon.Repo.Migrations.CreateConditions do
  use Ecto.Migration

  def change do
    create table(:conditions) do
      add :operator, :string
      add :value, :string

      timestamps()
    end

  end
end
