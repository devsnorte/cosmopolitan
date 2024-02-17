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
    |> build_slug()
    |> validate_required([:slug, :title, :start_datetime, :end_datetime, :location, :description])
    |> validate_format(:slug, ~r/([a-z]-)/)
    |> unique_constraint(:slug)
  end

  defp build_slug(%{changes: %{title: title}} = changeset) when is_binary(title) do
    if get_change(changeset, :slug) do
      changeset
    else
      put_change(changeset, :slug, Slug.slugify(title))
    end
  end

  defp build_slug(changeset) do
    changeset
  end
end
