defmodule Cosmopolitan.Repo.Migrations.UpdateEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :visibility, :boolean, default: false
    end
  end
end
