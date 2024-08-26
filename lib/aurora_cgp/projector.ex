defmodule AuroraCGP.Projector do
  use Commanded.Projections.Ecto,
    application: AuroraCGP,
    repo: AuroraCGP.Projector.Repo,
    name: "aurora_gcp-projector-main"


  alias AuroraCGP.Event.{PersonRegistered, OUCreated, MembershipStarted}
  alias AuroraCGP.Projector.Model.{Person, OU, Membership}

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

  project(
    %OUCreated{ou_id: ou_id, ou_name: ou_name, ou_goal: ou_goal, ou_description: ou_description},
    metadata,
    fn multi ->
      projection = %OU{
        ou_id: ou_id,
        ou_name: ou_name,
        ou_goal: ou_goal,
        ou_description: ou_description,
        ou_status: :active,
        created_at: metadata.created_at,
        updated_at: metadata.created_at
      }

      Ecto.Multi.insert(multi, :ou_table, projection)
    end
  )

  project(
    %MembershipStarted{membership_id: membership_id, ou_id: ou_id, person_id: person_id},
    metadata,
    fn multi ->
      projection = %Membership{
        membership_id: membership_id,
        ou_id: ou_id,
        person_id: person_id,
        membership_status: :junior,
        created_at: metadata.created_at,
        updated_at: metadata.created_at
      }

      Ecto.Multi.insert(multi, :membership_table, projection)
    end
  )

  @impl Commanded.Projections.Ecto
  def after_update(event, _metadata, _changes) do
    Phoenix.PubSub.broadcast(AuroraCGP.PubSub, "projector_update", :uo)
    IO.inspect(event, label: "Notificando")
    :ok
  end
end
