defmodule CosmopolitanWeb.AttendeeControllerTest do
  use CosmopolitanWeb.ConnCase

  import Cosmopolitan.MeetupFixtures
  import Cosmopolitan.AccountsFixtures

  alias Cosmopolitan.Meetup.Attendee

  @update_attrs %{
    checked_in: false
  }
  @invalid_attrs %{checked_in: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attendees", %{conn: conn} do
      event = event_fixture()
      conn = get(conn, ~p"/api/events/#{event.id}/attendees")
      assert json_response(conn, 200)["data"] == []
    end

    test "shows 404 if event does not exist", %{conn: conn} do
      assert_error_sent(404, fn ->
        get(conn, ~p"/api/events/1/attendees")
      end)
    end
  end

  describe "create attendee" do
    test "renders attendee when data is valid", %{conn: conn} do
      event = event_fixture()
      user = user_fixture()

      conn =
        post(conn, ~p"/api/events/#{event.id}/attendees",
          attendee: %{
            checked_in: true,
            user_id: user.id
          }
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/events/#{event.id}/attendees/#{id}")

      assert %{
               "id" => ^id,
               "checked_in" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      event = event_fixture()
      conn = post(conn, ~p"/api/events/#{event.id}/attendees", attendee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when foreign key does not exist", %{conn: conn} do
      event = event_fixture()
      user = user_fixture()

      conn =
        post(conn, ~p"/api/events/#{event.id}/attendees",
          attendee: %{
            checked_in: true,
            user_id: 100
          }
        )

      assert json_response(conn, 422)["errors"] != %{}

      conn =
        post(conn, ~p"/api/events/100/attendees",
          attendee: %{
            checked_in: true,
            user_id: user.id
          }
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag :todo
    test "does not add duplicate users on the same event", _params do
      raise "Not Implemented"
    end
  end

  describe "update attendee" do
    setup [:create_attendee]

    test "renders attendee when data is valid", %{
      conn: conn,
      attendee: %Attendee{id: id} = attendee,
      event: event
    } do
      conn = put(conn, ~p"/api/events/#{event.id}/attendees/#{attendee}", attendee: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/events/#{event.id}/attendees/#{id}")

      assert %{
               "id" => ^id,
               "checked_in" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, attendee: attendee, event: event} do
      conn =
        put(conn, ~p"/api/events/#{event.id}/attendees/#{attendee}", attendee: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete attendee" do
    setup [:create_attendee]

    test "deletes chosen attendee", %{conn: conn, attendee: attendee, event: event} do
      conn = delete(conn, ~p"/api/events/#{event.id}/attendees/#{attendee}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/api/events/#{event.id}/attendees/#{attendee}")
      end)
    end
  end

  defp create_attendee(_) do
    user = user_fixture()
    event = event_fixture()
    attendee = attendee_fixture(user.id, event.id)
    %{attendee: attendee, event: event, user: user}
  end
end
