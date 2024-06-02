defmodule AuroraCGP.Repo.Migrations.CreateAuthTable do
  use Ecto.Migration

  def change do

    create table(:auth_table, primary_key: false) do
      add :person_id, references(:person_table, [on_delete: :delete_all, column: :person_id, type: :string]), primary_key: true
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:auth_table, [:person_id])
    create unique_index(:auth_table, [:context, :token])
  end
end
