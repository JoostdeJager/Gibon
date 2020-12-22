defmodule Gibon.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :port, :string
      add :product_id, :integer

      timestamps()
    end

    create unique_index(:devices, [:port])
  end
end
