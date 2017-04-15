defmodule Chat.Repo.Migrations.CreateConvo do
  use Ecto.Migration

  def change do
    create table(:convos) do
      add :title, :string

      timestamps()
    end

    create unique_index(:convos, [:title])
  end
end
