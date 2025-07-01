import Config

# configuro il database
# !!! credenziali hardcodate per lo sviluppo
config :backend, Backend.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "backend_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :backend, BackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "jOtc8KlsASwC2ya3E3q71shz9dCF26abvAE+Cmro24Z/q+5dCF8+jgbPgp3qlNaw",
  watchers: []

config :backend, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false
