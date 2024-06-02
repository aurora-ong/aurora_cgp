defmodule AuroraCGP.Projector do
  use Commanded.Projections.Ecto,
    application: AuroraCGP,
    repo: AuroraCGP.Projector.Repo,
    name: "aurora_gcp-projector-main"

  alias AuroraCGP.Event.PersonRegistered
  alias AuroraCGP.Projector.Model.Person

  project(
    %PersonRegistered{person_id: person_id, person_name: person_name, person_mail: person_mail},
    metadata,
    fn multi ->
      projection = %Person{
        person_id: person_id,
        person_name: person_name,
        person_mail: person_mail,
        person_secret: Pbkdf2.hash_pwd_salt("test"),
        created_at: metadata.created_at,
        updated_at: metadata.created_at
      }

      Ecto.Multi.insert(multi, :person_table, projection)
    end
  )

  @impl Commanded.Projections.Ecto
  def after_update(event, _metadata, _changes) do
    # Phoenix.PubSub.broadcast(AuroraCommanded.PubSub, "projector_update", :uo)
    IO.inspect(event, label: "Notificando")
    :ok
  end
end
