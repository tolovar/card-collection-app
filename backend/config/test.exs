import Config

#configuro il database
config :backend, Backend.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "backend_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :backend, BackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "UItmkbewRQRyGpAwfxi+Q2ddPx95GtbrLIMNK2t4ZaMfCSlhVBfQU+TaCXqYVPiJ",
  server: false

  config :backend, Backend.Mailer, adapter: Swoosh.Adapters.Test

config :swoosh, :api_client, false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
