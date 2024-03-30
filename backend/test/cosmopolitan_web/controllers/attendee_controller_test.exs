defmodule CosmopolitanWeb.AttendeeControllerTest do
  use CosmopolitanWeb.ConnCase

  import Cosmopolitan.MeetupFixtures

  alias Cosmopolitan.Meetup.Attendee

  @create_attrs %{
    checked_in: true
  }
  @update_attrs %{
    checked_in: false
  }
  @invalid_attrs %{checked_in: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attendees", %{conn: conn} do
      conn = get(conn, ~p"/api/attendees")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create attendee" do
    test "renders attendee when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/attendees", attendee: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/attendees/#{id}")

      assert %{
               "id" => ^id,
               "checked_in" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/attendees", attendee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update attendee" do
    setup [:create_attendee]

    test "renders attendee when data is valid", %{conn: conn, attendee: %Attendee{id: id} = attendee} do
      conn = put(conn, ~p"/api/attendees/#{attendee}", attendee: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/attendees/#{id}")

      assert %{
               "id" => ^id,
               "checked_in" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, attendee: attendee} do
      conn = put(conn, ~p"/api/attendees/#{attendee}", attendee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete attendee" do
    setup [:create_attendee]

    test "deletes chosen attendee", %{conn: conn, attendee: attendee} do
      conn = delete(conn, ~p"/api/attendees/#{attendee}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/attendees/#{attendee}")
      end
    end
  end

  defp create_attendee(_) do
    attendee = attendee_fixture()
    %{attendee: attendee}
  end
end
