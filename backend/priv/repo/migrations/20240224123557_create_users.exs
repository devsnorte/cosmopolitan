defmodule Cosmopolitan.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
