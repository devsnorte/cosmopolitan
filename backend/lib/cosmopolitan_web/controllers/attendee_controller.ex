defmodule CosmopolitanWeb.AttendeeController do
  use CosmopolitanWeb, :controller

  alias Cosmopolitan.Meetup
  alias Cosmopolitan.Meetup.Attendee

  action_fallback CosmopolitanWeb.FallbackController

  def index(conn, _params) do
    attendees = Meetup.list_attendees()
    render(conn, :index, attendees: attendees)
  end

  def create(conn, %{"attendee" => attendee_params}) do
    with {:ok, %Attendee{} = attendee} <- Meetup.create_attendee(attendee_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/attendees/#{attendee}")
      |> render(:show, attendee: attendee)
    end
  end

  def show(conn, %{"id" => id}) do
    attendee = Meetup.get_attendee!(id)
    render(conn, :show, attendee: attendee)
  end

  def update(conn, %{"id" => id, "attendee" => attendee_params}) do
    attendee = Meetup.get_attendee!(id)

    with {:ok, %Attendee{} = attendee} <- Meetup.update_attendee(attendee, attendee_params) do
      render(conn, :show, attendee: attendee)
    end
  end

  def delete(conn, %{"id" => id}) do
    attendee = Meetup.get_attendee!(id)

    with {:ok, %Attendee{}} <- Meetup.delete_attendee(attendee) do
      send_resp(conn, :no_content, "")
    end
  end
end
