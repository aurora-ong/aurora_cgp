# AuroraCGP

ERP con tecnología política que implementa el Modelo Aurora. Más información en https://aurora.ong


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Instrucciones 

1. Ejecutar `mix deps.get`
2. Correr instancia DB 
`docker run --env=POSTGRES_PASSWORD=aurora -p 4500:5432 --name=aurora-commanded -d postgres:latest`
3. Comprobar configuración de DBs (son 2) `config/config.exs`
4. Inicializar eventstore DB (donde se guardan los eventos)
* `mix do event_store.create`
* `mix do event_store.init`
5. Inicializar projector DB (donde se projecta la data)
* `mix ecto.create`
* `mix ecto.migrate`

6. Ejecutar aplicación utilizando iex `iex -S mix phx.server`
7. Visitar [`localhost:4000`](http://localhost:4000) para ver la interfaz del ERP

## Enviar comandos

Registrar persona (usuario en el sistema)
`:ok = AuroraCGP.dispatch(%AuroraCGP.Command.RegisterPerson{person_id: "333", person_name: "Pedro Diaz", person_mail: "p.diaz@gmail.com"})`


