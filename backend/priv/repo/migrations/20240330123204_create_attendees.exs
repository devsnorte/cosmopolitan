defmodule Cosmopolitan.Repo.Migrations.CreateAttendees do
  use Ecto.Migration

  def change do
    create table(:attendees) do
      add :checked_in, :boolean, default: false, null: false
      add :event_id, references(:events, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:attendees, [:event_id])
    create index(:attendees, [:user_id])
  end
end
