defmodule Inflow.Import.Manifest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "manifests" do
    field :columns, {:array, :string}
    field :is_auction, :boolean, default: false
    field :partner_id, :string
    field :state, :string, default: "pending"

    timestamps()
  end

  @doc false
  def changeset(manifest, attrs) do
    manifest
    |> cast(attrs, [:partner_id, :is_auction, :state, :columns])
    |> validate_required([:partner_id, :is_auction])
  end
end
