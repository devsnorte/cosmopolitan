defmodule CosmopolitanWeb.EventJSON do
  alias Cosmopolitan.Meetup.Event

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      slug: event.slug,
      title: event.title,
      start_datetime: event.start_datetime,
      end_datetime: event.end_datetime,
      location: event.location,
      description: event.description,
      visibility: event.visibility
    }
  end
end
