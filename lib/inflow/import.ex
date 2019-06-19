defmodule Inflow.Import do
  @moduledoc """
  The Import context.
  """

  import Ecto.Query, warn: false
  alias Inflow.Repo

  alias Inflow.Import.Manifest

  @doc """
  Returns the list of manifests.

  ## Examples

      iex> list_manifests()
      [%Manifest{}, ...]

  """
  def list_manifests do
    Repo.all(Manifest)
  end

  @doc """
  Gets a single manifest.

  Raises `Ecto.NoResultsError` if the Manifest does not exist.

  ## Examples

      iex> get_manifest!(123)
      %Manifest{}

      iex> get_manifest!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manifest!(id), do: Repo.get!(Manifest, id)

  @doc """
  Creates a manifest.

  ## Examples

      iex> create_manifest(%{field: value})
      {:ok, %Manifest{}}

      iex> create_manifest(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manifest(attrs \\ %{}) do
    %Manifest{}
    |> Manifest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a manifest.

  ## Examples

      iex> update_manifest(manifest, %{field: new_value})
      {:ok, %Manifest{}}

      iex> update_manifest(manifest, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manifest(%Manifest{} = manifest, attrs) do
    manifest
    |> Manifest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Manifest.

  ## Examples

      iex> delete_manifest(manifest)
      {:ok, %Manifest{}}

      iex> delete_manifest(manifest)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manifest(%Manifest{} = manifest) do
    Repo.delete(manifest)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manifest changes.

  ## Examples

      iex> change_manifest(manifest)
      %Ecto.Changeset{source: %Manifest{}}

  """
  def change_manifest(%Manifest{} = manifest) do
    Manifest.changeset(manifest, %{})
  end
end
