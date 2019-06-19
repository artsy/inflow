defmodule Inflow.Repo.Migrations.CreateManifests do
  use Ecto.Migration

  def change do
    create table(:manifests) do
      add :partner_id, :string, null: false
      add :state, :string, default: "pending", null: false
      add :is_auction, :boolean, default: false, null: false
      add :columns, {:array, :string}

      timestamps()
    end

    create index("manifests", :partner_id)
  end
end
