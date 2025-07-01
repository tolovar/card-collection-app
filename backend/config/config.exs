# questo file viene caricato prima di tutti gli altri all'avvio dell'applicazione

import Config

config :backend,
  ecto_repos: [Backend.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# configuro gli endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: BackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Backend.PubSub,
  live_view: [signing_salt: "a9bJrmVH"]

# configuro il mailer
config :backend, Backend.Mailer, adapter: Swoosh.Adapters.Local

# configuro il logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# uso Jason per il parsing JSON in Phoenix
config :phoenix, :json_library, Jason

# importo tutte le configurazioni per l'ambiente
import_config "#{config_env()}.exs"

# configurazione generale del repo
config :backend,
  ecto_repos: [Backend.Repo]

# configurazione del database
config :backend, Backend.Repo,
  username: "postgres",
  password: "postgres",
  database: "card_collection_app_dev",
  hostname: "localhost",
  pool_size: 100,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# configurazione di Guardian per l'autenticazione
config :backend, Backend.Guardian,
  issuer: "backend",
  secret_key: "SOSTITUISCI_QUESTO_CON_UNA_CHIAVE_FORTISSIMA_ANZI_INVINCIBILE"

# livello di log
config :logger, level: :info

# configurazioni specifiche per l'ambiente
import_config "#{Mix.env()}.exs"
