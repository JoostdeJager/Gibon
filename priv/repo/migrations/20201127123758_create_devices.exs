defmodule Gibon.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :port, :string
      add :product_id, :integer
      add :listening, :boolean

      timestamps()
    end

    create unique_index(:devices, [:port])
  end
end
