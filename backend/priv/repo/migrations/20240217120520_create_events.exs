defmodule Cosmopolitan.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :slug, :string
      add :title, :string
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :location, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:events, [:slug])
  end
end
