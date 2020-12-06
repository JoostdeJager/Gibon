defmodule Gibon.Serial.Condition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conditions" do
    field :operator, :string
    field :value, :string
    field :url, :string
    belongs_to :device, Gibon.Serial.Device

    timestamps()
  end

  @doc false
  def changeset(condition, attrs) do
    condition
    |> cast(attrs, [:operator, :value, :url])
    |> validate_required([:operator, :value, :url])
    |> unique_constraint(:value)
  end
end
