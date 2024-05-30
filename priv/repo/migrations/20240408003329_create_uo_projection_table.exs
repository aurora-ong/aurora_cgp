defmodule NEOS.Repo.Migrations.Projector.CreatePersonTable do
  use Ecto.Migration

  def change do
    create table(:person_table, primary_key: false) do
      add :person_id, :string, primary_key: true
      add :person_name, :string
      add :person_mail, :string
      add :created_at, :utc_datetime_usec
      add :updated_at, :utc_datetime_usec
    end

    create index(:person_table, [:person_id])
  end
end
