defmodule AuroraCGP.Projector.Model.Person do
  use Ecto.Schema

  @primary_key {:person_id, :string, autogenerate: false}
  schema "person_table" do
    field :person_name, :string
    field :person_mail, :string
    field :created_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
  end
end
