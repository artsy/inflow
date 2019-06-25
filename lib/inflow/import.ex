defmodule Inflow.Import do
  @moduledoc """
  The Import context.
  """
  alias NimbleCSV.RFC4180, as: CSV

  import Ecto.Query, warn: false
  alias ExAws.S3
  alias Inflow.Repo

  alias Inflow.Import.Manifest

  @artsy_current_bucket "artsy-currents-development"
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
  Reutrns new Manifest given a file_path. It will:
   - store the file on S3
   - create a new manifest
  """
  def start_upload(file_path, file_name, partner_id, is_auction \\ false) do
    # upload to S3
    with {:ok, manifest} <-
           create_manifest(%{partner_id: partner_id, is_auction: is_auction, file_name: file_name}),
         {:ok, _} <- upload_to_s3(manifest, file_path) do
      spawn(Inflow.Import, :process_csv, [manifest])
      {:ok, manifest}
    else
      error -> IO.inspect(error)
    end
  end

  defp upload_to_s3(manifest, file_path) do
    file_path
    |> S3.Upload.stream_file()
    |> S3.upload(@artsy_current_bucket, "#{manifest.partner_id}/#{manifest.id}.csv")
    |> ExAws.request()
  end

  def process_csv(manifest) do
    S3.download_file(@artsy_current_bucket, "#{manifest.partner_id}/#{manifest.id}.csv", "/tmp/#{manifest.id}.csv")
    |> ExAws.request!

    File.stream!("/tmp/#{manifest.id}.csv")
    |> CSV.parse_stream(skip_headers: true)
    |> Enum.map(&Inflow.Import.process_row(&1, manifest))

    :timer.sleep(Enum.random(1..6) * 1000)
    InflowWeb.Endpoint.broadcast("manifests:#{manifest.id}", "manifest_updated", %{state: "completed"})
  end

  def process_row(csv_row, manifest) do
    :timer.sleep(Enum.random(1..6) * 1000)
    InflowWeb.Endpoint.broadcast("manifests:#{manifest.id}", "manifest_row_created", %{manifest_row: %{name: Enum.fetch!(csv_row, 0), title: Enum.fetch!(csv_row, 1)}})
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
