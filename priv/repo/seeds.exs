# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AuroraCGP.Repo.insert!(%AuroraCGP.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


Faker.start()

persons = for _i <- 1..10 do

  uuid = Faker.UUID.v4()
  person_command = %AuroraCGP.Command.RegisterPerson{
    person_id: uuid,
    person_name: Faker.Person.name(),
    person_mail: Faker.Internet.email()
  }

  :ok = AuroraCGP.dispatch(person_command)

  IO.inspect(person_command, label: "Person Command")
  uuid

end

organizacions = for _i <- 1..5 do

  org_name = Faker.Address.city();
  uuid = org_name
  |> String.replace([" "], "")
  |> String.downcase()

  organization_command = %AuroraCGP.Command.CreateOU{
    ou_id: uuid,
    ou_name: org_name,
    ou_description: Faker.Company.bs,
    ou_goal: Faker.Company.bs
  }

  :ok = AuroraCGP.dispatch(organization_command)

  IO.inspect(organization_command, label: "Org Command")
  uuid

end

members = for _i <- 1..3 do

  org_id = Enum.random(organizacions);
  person_id = Enum.random(persons);


  membership_command = %AuroraCGP.Command.StartMembership{
    ou_id: org_id,
    person_id: person_id
  }

  :ok = AuroraCGP.dispatch(membership_command)

  IO.inspect(membership_command, label: "Membership Command")

end
