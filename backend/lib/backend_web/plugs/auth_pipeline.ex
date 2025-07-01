defmodule BackendWeb.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :backend,
    module: Backend.Guardian,
    error_handler: BackendWeb.AuthErrorHandler

  # verifico la presenza e la validità del token
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug BackendWeb.Plugs.LoadUserFromToken
end

# aggiungo un plug dopo l'autenticazione per accedere
# ai dati dell'utente autenticato tramite il token
# posso accedere ai dati dell'utente in tutti i controller
# senza dover fare una query al database
# e senza dover passare l'id dell'utente come parametro
defmodule BackendWeb.Plugs.LoadUserFromToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    claims = Guardian.Plug.current_claims(conn)
    if user_map = claims["user"] do
      assign(conn, :current_user, user_map)
    else
      conn
    end
  end
end
