defmodule Seeds.Utils do

  def generate(parent_id, _persons, 0, _childs) do
    IO.inspect("Hola FIN GG")
    # Seeds.Utils.generate("hola", [], 3, 3)
    command = generate_org(parent_id)
      IO.inspect(command, label: "#{parent_id},0")
  end

  def generate(parent_id , persons \\ [], level, childs) do
    IO.inspect("Hola GG #{level}")

    command = generate_org(parent_id)

    for i <- 1..childs do
      generate(command.ou_id, [], level-1, childs)
    end


  end

  def generate_org(parent_id \\ nil) do
    org_name = Faker.Address.city()

    org_id =
      org_name
      |> String.replace([" "], "")
      |> String.downcase()

      org_id = if (parent_id != nil), do: "#{parent_id}.#{org_id}", else: org_id

    organization_command = %AuroraCGP.Command.CreateOU{
      ou_id: org_id,
      ou_name: org_name,
      ou_description: Faker.Company.bs(),
      ou_goal: Faker.Company.catch_phrase()
    }

    IO.inspect(organization_command, label: "#{parent_id}")
  end


end
