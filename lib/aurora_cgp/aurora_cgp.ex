defmodule AuroraCGP do
  use Commanded.Application,
    otp_app: :aurora_cgp,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: AuroraCGP.EventStore
    ]

  # pubsub: [
  #   phoenix_pubsub: [
  #     adapter: Phoenix.PubSub.PG2,
  #     pool_size: 1
  #   ]
  # ]

  router(AuroraCGP.Router)
end
