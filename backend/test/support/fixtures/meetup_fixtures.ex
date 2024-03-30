defmodule Cosmopolitan.MeetupFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cosmopolitan.Meetup` context.
  """

  @doc """
  Generate a unique event slug.
  """
  def unique_event_slug, do: "some-slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_datetime: ~U[2224-02-16 12:05:00Z],
        location: "some location",
        slug: unique_event_slug(),
        start_datetime: ~U[2224-02-16 12:05:00Z],
        title: "some title"
      })
      |> Cosmopolitan.Meetup.create_event()

    event
  end

  @doc """
  Generate a attendee.
  """
  def attendee_fixture(attrs \\ %{}) do
    {:ok, attendee} =
      attrs
      |> Enum.into(%{
        checked_in: true
      })
      |> Cosmopolitan.Meetup.create_attendee()

    attendee
  end
end
