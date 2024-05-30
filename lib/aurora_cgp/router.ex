defmodule AuroraCGP.Router do
  use Commanded.Commands.Router
  alias AuroraCGP.Command.RegisterPerson
  alias AuroraCGP.CommandHandler.RegisterPersonHandler
  alias AuroraCGP.Aggregate.Person

  dispatch RegisterPerson, to: RegisterPersonHandler, aggregate: Person, identity: :person_id

end
