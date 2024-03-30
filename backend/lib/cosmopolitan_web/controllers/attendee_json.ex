defmodule CosmopolitanWeb.AttendeeJSON do
  alias Cosmopolitan.Meetup.Attendee

  @doc """
  Renders a list of attendees.
  """
  def index(%{attendees: attendees}) do
    %{data: for(attendee <- attendees, do: data(attendee))}
  end

  @doc """
  Renders a single attendee.
  """
  def show(%{attendee: attendee}) do
    %{data: data(attendee)}
  end

  defp data(%Attendee{} = attendee) do
    %{
      id: attendee.id,
      checked_in: attendee.checked_in
    }
  end
end
