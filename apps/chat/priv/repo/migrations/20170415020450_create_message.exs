defmodule Chat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :convo_id, references(:convos, on_delete: :nothing)

      timestamps()
    end
    
    create index(:messages, [:user_id])
    create index(:messages, [:convo_id])
  end
end
