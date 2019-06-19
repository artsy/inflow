defmodule Inflow.ImportTest do
  use Inflow.DataCase

  alias Inflow.Import

  describe "manifests" do
    alias Inflow.Import.Manifest

    @valid_attrs %{columns: [], is_auction: true, partner_id: "some partner_id"}
    @update_attrs %{
      columns: ["col1", "col2"],
      state: "some updated state"
    }
    @invalid_attrs %{columns: nil, is_auction: nil, partner_id: nil, state: nil}

    def manifest_fixture(attrs \\ %{}) do
      {:ok, manifest} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Import.create_manifest()

      manifest
    end

    test "list_manifests/0 returns all manifests" do
      manifest = manifest_fixture()
      assert Import.list_manifests() == [manifest]
    end

    test "get_manifest!/1 returns the manifest with given id" do
      manifest = manifest_fixture()
      assert Import.get_manifest!(manifest.id) == manifest
    end

    test "create_manifest/1 with valid data creates a manifest" do
      assert {:ok, %Manifest{} = manifest} = Import.create_manifest(@valid_attrs)
      assert manifest.columns == []
      assert manifest.is_auction == true
      assert manifest.partner_id == "some partner_id"
      # verify default value of state
      assert manifest.state == "pending"
    end

    test "create_manifest/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Import.create_manifest(@invalid_attrs)
    end

    test "update_manifest/2 with valid data updates the manifest" do
      manifest = manifest_fixture()
      assert {:ok, %Manifest{} = manifest} = Import.update_manifest(manifest, @update_attrs)
      assert manifest.columns == ["col1", "col2"]
      assert manifest.state == "some updated state"
    end

    test "update_manifest/2 with invalid data returns error changeset" do
      manifest = manifest_fixture()
      assert {:error, %Ecto.Changeset{}} = Import.update_manifest(manifest, @invalid_attrs)
      assert manifest == Import.get_manifest!(manifest.id)
    end

    test "delete_manifest/1 deletes the manifest" do
      manifest = manifest_fixture()
      assert {:ok, %Manifest{}} = Import.delete_manifest(manifest)
      assert_raise Ecto.NoResultsError, fn -> Import.get_manifest!(manifest.id) end
    end

    test "change_manifest/1 returns a manifest changeset" do
      manifest = manifest_fixture()
      assert %Ecto.Changeset{} = Import.change_manifest(manifest)
    end
  end
end
