defmodule Gibon.Serial.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :port, :string
    field :product_id, :integer

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:port, :product_id])
    |> validate_required([:port, :product_id])
    |> unique_constraint(:port)
  end
end
