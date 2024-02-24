defmodule CosmopolitanWeb.EventControllerTest do
  use CosmopolitanWeb.ConnCase

  import Cosmopolitan.MeetupFixtures

  alias Cosmopolitan.Meetup.Event

  @create_attrs %{
    description: "some description",
    end_datetime: ~U[2224-02-16 12:05:00Z],
    location: "some location",
    start_datetime: ~U[2224-02-16 12:05:00Z],
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    end_datetime: ~U[2224-02-17 12:05:00Z],
    location: "some updated location",
    slug: "some-updated-slug",
    start_datetime: ~U[2224-02-17 12:05:00Z],
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, end_datetime: nil, location: nil, slug: nil, start_datetime: nil, title: nil}
  @update_visibility_attrs %{"visibility" => true}
  @update_visibility_invalid_attrs %{"visibility" => "anything"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/api/events")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "end_datetime" => "2224-02-16T12:05:00Z",
               "location" => "some location",
               "slug" => "some-title",
               "start_datetime" => "2224-02-16T12:05:00Z",
               "title" => "some title",
               "visibility" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "end_datetime" => "2224-02-17T12:05:00Z",
               "location" => "some updated location",
               "slug" => "some-updated-slug",
               "start_datetime" => "2224-02-17T12:05:00Z",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders success when visibility is updated to true", %{conn: conn, event: event} do
      conn = patch(conn, ~p"/api/events/#{event}", @update_visibility_attrs)
      assert json_response(conn, 200) == %{}
    end

    test "renders error when visibility is not a boolean", %{conn: conn, event: event} do
      conn = patch(conn, ~p"/api/events/#{event}", @update_visibility_invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/events/#{event}")
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
