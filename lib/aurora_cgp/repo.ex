defmodule AuroraCGP.Projection.Repo do
  use Ecto.Repo,
    otp_app: :aurora_cgp,
    adapter: Ecto.Adapters.Postgres
end
