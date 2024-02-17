defmodule Cosmopolitan.Repo do
  use Ecto.Repo,
    otp_app: :cosmopolitan,
    adapter: Ecto.Adapters.Postgres
end
