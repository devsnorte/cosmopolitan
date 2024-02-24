defmodule CosmopolitanWeb.EventController do
  use CosmopolitanWeb, :controller

  alias Cosmopolitan.Meetup
  alias Cosmopolitan.Meetup.Event

  plug CosmopolitanWeb.Plugs.RequireAuthPlug, [] when action in [:create, :update, :delete]

  action_fallback CosmopolitanWeb.FallbackController

  def index(conn, _params) do
    events = Meetup.list_events()
    render(conn, :index, events: events)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Meetup.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/events/#{event}")
      |> render(:show, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Meetup.get_event!(id)
    render(conn, :show, event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Meetup.get_event!(id)

    with {:ok, %Event{} = event} <- Meetup.update_event(event, event_params) do
      render(conn, :show, event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Meetup.get_event!(id)

    with {:ok, %Event{}} <- Meetup.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
