# AuroraCGP

Plataforma colaborativa con gobernanza colectiva. 

Más información en https://aurora.ong
Para contribuir contacta a Pavel Delgado (p.delgado@aurora.ong)

## Requerimientos

* Docker
* Elixir

## Instrucciones 

1. Ejecutar `mix deps.get`
2. Correr instancia DB 
`docker run --env=POSTGRES_PASSWORD=aurora_cgp -p 4500:5432 --name=aurora-cgp -d postgres:latest`
3. Comprobar configuración de DBs (son 2) `config/config.exs`
4. Inicializar DB 
`mix db.setup`
5. Ejecutar aplicación utilizando iex `iex -S mix phx.server`
6. Visitar [`localhost:4000`](http://localhost:4000) para acceder a la interfaz

## Enviar comandos

### Registrar persona

`%AuroraCGP.Projector.Model.Person{} = AuroraCGP.Context.PersonContext.register_person!(%{person_name: "Camila Saez", person_mail: "c.saez@gmail.com"})`

`%AuroraCGP.Projector.Model.Person{} = AuroraCGP.Context.PersonContext.register_person!(%{person_name: "Pedro Diaz", person_mail: "p.diaz@gmail.com"})`

### Crear una unidad organizacional

`:ok = AuroraCGP.dispatch(%AuroraCGP.Command.CreateOU{ou_id: "raiz", ou_name: "Raiz ORG", ou_description: "Creada para enraizar", ou_goal: "Fomentar la cultura de raíz"})`

`:ok = AuroraCGP.dispatch(%AuroraCGP.Command.CreateOU{ou_id: "raiz.sub", ou_name: "SUB Departamento finanzas", ou_description: "Creada para financiar", ou_goal: "Financiar la organización"})`

### Iniciar una membresía

`:ok = AuroraCGP.dispatch(%AuroraCGP.Command.StartMembership{ou_id: "raiz", person_id: "111"})`

`:ok = AuroraCGP.dispatch(%AuroraCGP.Command.StartMembership{ou_id: "raiz", person_id: "333"})`
`:ok = AuroraCGP.dispatch(%AuroraCGP.Command.StartMembership{ou_id: "raiz.sub", person_id: "333"})`

