

# config/config.exs

config :my_app, MyApp.Guardian,
  issuer: "my_app",
  secret_key: System.fetch_env!("GUARDIAN_SECRET_KEY")



# lib/my_app/guardian.ex

defmodule MyApp.Guardian do
  use Guardian, otp_app: :my_app

  alias MyApp.{Repo, Accounts.User}

  # Subject: come rappresento la risorsa nel token
  def subject_for_token(%User{id: id}, _claims), do: {:ok, to_string(id)}
  def subject_for_token(_, _), do: {:error, :reason}

  # Recupero della risorsa a partire dai claims
  def resource_from_claims(%{"sub" => id}) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end



# lib/my_app_web/auth_pipeline.ex

defmodule MyAppWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :my_app,
    module: MyApp.Guardian,
    error_handler: MyAppWeb.AuthErrorHandler

  # 1. verifico il token JWT nella richiesta
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  # 2. mi assicuro che il login sia avvenuto
  plug Guardian.Plug.EnsureAuthenticated
  # 3. carico la risorsa utente associata al token
  plug Guardian.Plug.LoadResource, allow_blank: false
end


# lib/my_app_web/controllers/session_controller.ex

defmodule MyAppWeb.SessionController do
  use MyAppWeb, :controller
  alias MyApp.{Accounts, Guardian}

  # creo una sessione per l'utente autenticato
  # riceve email e password come parametri
  def create(conn, %{"email" => email, "password" => password}) do
    # verifico le credenziali dell'utente
    # se sono valide, genero un token JWT e lo restituisco
    with {:ok, user} <- Accounts.authenticate_user(email, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      json(conn, %{access_token: token})
    # se le credenziali non sono valide, restituisco un errore
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Credenziali non valide"})
    end
  end
end
