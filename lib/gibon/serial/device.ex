defmodule Gibon.Serial.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :port, :string
    field :product_id, :integer
    has_many :conditions, Gibon.Serial.Condition, on_delete: :delete_all

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
