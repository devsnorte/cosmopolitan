defmodule Cosmopolitan.Meetup.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :description, :string
    field :end_datetime, :utc_datetime
    field :location, :string
    field :slug, :string
    field :start_datetime, :utc_datetime
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:slug, :title, :start_datetime, :end_datetime, :location, :description])
    |> validate_required([:slug, :title, :start_datetime, :end_datetime, :location, :description])
    |> unique_constraint(:slug)
  end
end
