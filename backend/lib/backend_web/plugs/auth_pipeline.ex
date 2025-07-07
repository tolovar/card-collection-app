defmodule BackendWeb.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :backend,
    module: Backend.Guardian,
    error_handler: BackendWeb.AuthErrorHandler

  # verifico la presenza e la validità del token
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
end
