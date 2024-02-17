defmodule Cosmopolitan.MeetupTest do
  use Cosmopolitan.DataCase

  alias Cosmopolitan.Meetup

  describe "events" do
    alias Cosmopolitan.Meetup.Event

    import Cosmopolitan.MeetupFixtures

    @invalid_attrs %{description: nil, end_datetime: nil, location: nil, slug: nil, start_datetime: nil, title: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Meetup.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Meetup.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{description: "some description", end_datetime: ~U[2224-02-16 12:05:00Z], location: "some location", slug: "some-slug", start_datetime: ~U[2224-02-18 12:05:00Z], title: "some title"}

      assert {:ok, %Event{} = event} = Meetup.create_event(valid_attrs)
      assert event.description == "some description"
      assert event.end_datetime == ~U[2224-02-16 12:05:00Z]
      assert event.location == "some location"
      assert event.slug == "some-slug"
      assert event.start_datetime == ~U[2224-02-18 12:05:00Z]
      assert event.title == "some title"
    end

    test "create_event/1 cannot use dates in the past" do
      invalid_attrs = %{description: "some description", end_datetime: ~U[2024-02-16 12:05:00Z], location: "some location", slug: "some-slug", start_datetime: ~U[2024-02-16 12:05:00Z], title: "some title"}

      assert {:error, %Ecto.Changeset{} = changeset} = Meetup.create_event(invalid_attrs)
      assert Keyword.get(changeset.errors, :start_datetime) == {"cannot be in the past", []}
      assert Keyword.get(changeset.errors, :end_datetime) == {"cannot be in the past", []}
    end

    test "create_event/1 without a slug generates a slug" do
      valid_attrs = %{description: "some description", end_datetime: ~U[2224-02-16 12:05:00Z], location: "some location", start_datetime: ~U[2224-02-16 12:05:00Z], title: "some title"}

      assert {:ok, %Event{} = event} = Meetup.create_event(valid_attrs)
      assert event.description == "some description"
      assert event.end_datetime == ~U[2224-02-16 12:05:00Z]
      assert event.location == "some location"
      assert event.slug == "some-title"
      assert event.start_datetime == ~U[2224-02-16 12:05:00Z]
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meetup.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{description: "some updated description", end_datetime: ~U[2224-02-17 12:05:00Z], location: "some updated location", slug: "some-updated-slug", start_datetime: ~U[2224-02-17 12:05:00Z], title: "some updated title"}

      assert {:ok, %Event{} = event} = Meetup.update_event(event, update_attrs)
      assert event.description == "some updated description"
      assert event.end_datetime == ~U[2224-02-17 12:05:00Z]
      assert event.location == "some updated location"
      assert event.slug == "some-updated-slug"
      assert event.start_datetime == ~U[2224-02-17 12:05:00Z]
      assert event.title == "some updated title"
    end

    test "update_event/2 should not change the slug if it already exists" do
      old_event = event_fixture()
      update_attrs = %{title: "another updated title"}

      assert {:ok, %Event{} = event} = Meetup.update_event(old_event, update_attrs)
      assert event.title == "another updated title"
      assert event.slug == old_event.slug
    end

    test "update_event/2 slugs can be just one word" do
      old_event = event_fixture()
      update_attrs = %{slug: "event1"}

      assert {:ok, %Event{} = event} = Meetup.update_event(old_event, update_attrs)
      assert event.slug == "event1"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Meetup.update_event(event, @invalid_attrs)
      assert event == Meetup.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Meetup.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Meetup.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Meetup.change_event(event)
    end
  end
end
