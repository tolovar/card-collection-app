defmodule BackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :backend

  # archivio la sessione in un cookie firmato
  @session_options [
    store: :cookie,
    key: "_backend_key",
    signing_salt: "4jjxaokA",
    same_site: "Lax" # "Lax" per evitare CSRF (Cross-site request forgery), può essere "None" se si usa HTTPS
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :backend,
    gzip: false,
    only: BackendWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :backend
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BackendWeb.Router
end
