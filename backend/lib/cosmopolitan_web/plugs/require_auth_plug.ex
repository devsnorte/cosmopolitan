defmodule CosmopolitanWeb.Plugs.RequireAuthPlug do
  import Plug.Conn
  use CosmopolitanWeb, :controller

  alias Cosmopolitan.Accounts

  def init(options) do
    options
  end

  def call(conn, _opts) do
    with {:ok, token} <- fetch_authorization_from_conn(conn),
         :ok <- verify_authetication(token) do
      conn
    else
      _ ->
        conn
        |> put_status(:forbidden)
        |> put_view(html: CosmopolitanWeb.ErrorHTML, json: CosmopolitanWeb.ErrorJSON)
        |> render(:"403")
        |> halt()
    end
  end

  defp verify_authetication(token) do
    case Accounts.verify_user_token(token) do
      {:ok, _user_id} ->
        :ok

      _ ->
        {:error, :forbidden}
    end
  end

  defp fetch_authorization_from_conn(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [token] ->
        {:ok, token}

      _ ->
        {:error, :forbidden}
    end
  end
end
