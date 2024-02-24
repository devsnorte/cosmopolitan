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
    field :visibility, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:slug, :title, :start_datetime, :end_datetime, :location, :description, :visibility])
    |> build_slug()
    |> validate_required([:slug, :title, :start_datetime, :end_datetime, :location, :description])
    |> validate_format(:slug, ~r/([a-z0-9]|-)/)
    |> validate_change(:start_datetime, &validate_date_in_future/2)
    |> validate_change(:end_datetime, &validate_date_in_future/2)
    |> validate_end_datetime_larger_than_start()
    |> unique_constraint(:slug)
  end

  defp build_slug(%{changes: %{title: title}} = changeset) when is_binary(title) do
    if get_change(changeset, :slug) || changeset.data.slug != nil do
      changeset
    else
      put_change(changeset, :slug, Slug.slugify(title))
    end
  end

  defp build_slug(changeset) do
    changeset
  end

  defp validate_date_in_future(key, value) do
    now = DateTime.utc_now()
    if DateTime.diff(value, now) < 0 do
      [{key, "cannot be in the past"}]
    else
      []
    end
  end

  defp validate_end_datetime_larger_than_start(changeset) do
    start_date = get_change(changeset, :start_datetime)
    end_date = get_change(changeset, :end_datetime)

    if start_date != nil && end_date != nil && DateTime.diff(end_date, start_date) < 0 do
      add_error(changeset, :end_datetime, "cannot be before start_datetime")
    else
      changeset
    end
  end
end
