defmodule Chat.Repo.Migrations.AddCsColumnToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :cs, :string
    end
  end
end
