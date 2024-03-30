defmodule Cosmopolitan.Meetup.Attendee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attendees" do
    field(:checked_in, :boolean, default: false)
    field(:event_id, :id)
    field(:user_id, :id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attendee, attrs) do
    attendee
    |> cast(attrs, [:checked_in, :event_id, :user_id])
    |> validate_required([:checked_in, :event_id, :user_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:event_id)
  end
end
