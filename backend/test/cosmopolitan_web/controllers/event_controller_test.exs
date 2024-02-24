defmodule CosmopolitanWeb.EventControllerTest do
  use CosmopolitanWeb.ConnCase

  import Cosmopolitan.MeetupFixtures
  import Cosmopolitan.AccountsFixtures

  alias Cosmopolitan.Accounts
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
    title: "some updated title",
    visibility: true
  }
  @invalid_attrs %{description: nil, end_datetime: nil, location: nil, slug: nil, start_datetime: nil, title: nil}

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
      user = user_fixture()
      token = Accounts.generate_token_for_user(user)
      conn = Plug.Conn.put_req_header(conn, "authorization", token)
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

    test "send 403 when user is not logged in", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert json_response(conn, 403)
    end

    test "send 403 when user token is invalid", %{conn: conn} do
      conn = Plug.Conn.put_req_header(conn, "authorization", "seilamano")
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert json_response(conn, 403)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      token = Accounts.generate_token_for_user(user)
      conn = Plug.Conn.put_req_header(conn, "authorization", token)
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
               "title" => "some updated title",
               "visibility" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
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
