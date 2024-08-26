defmodule AuroraCGP.Router do
  use Commanded.Commands.Router
  alias AuroraCGP.Command.{RegisterPerson, CreateOU, StartMembership}
  alias AuroraCGP.CommandHandler.{RegisterPersonHandler, CreateOUHandler, StartMembershipHandler}
  alias AuroraCGP.Aggregate.{Person, OU}

  dispatch RegisterPerson, to: RegisterPersonHandler, aggregate: Person, identity: :person_id
  dispatch CreateOU, to: CreateOUHandler, aggregate: OU, identity: :ou_id
  dispatch StartMembership, to: StartMembershipHandler, aggregate: OU, identity: :ou_id

end
