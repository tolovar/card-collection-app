defmodule BackendWeb.AuthController do
  use BackendWeb, :controller
  alias Backend.Accounts
  alias Backend.Guardian

  # TODO: Controlla che tutte le API siano implementate correttamente, valuta se aggiungere altre fuonzionalità

  # registro un nuovo utente
  def register(conn, %{"email" => email, "password" => password}) do
    case Accounts.register_user(%{"email" => email, "password" => password}) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{
          token: token,
          user: %{
            id: user.id,
            email: user.email,
            is_admin: user.is_admin,
            role: user.role
          }
        })
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Errore nella registrazione", details: changeset.errors})
    end
  end

  # effettuo il login dell'utente
  def login(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_user_by_email(email)
    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{
          token: token,
          user: %{
            id: user.id,
            email: user.email,
            is_admin: user.is_admin,
            role: user.role
          }
        })
      true ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Credenziali non valide"})
    end
  end

  # logout stateless, lato client basta eliminare il token
  def logout(conn, _params) do
    json(conn, %{message: "Logout effettuato. Elimina il token lato client."})
  end

  # refresh token
  def refresh(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    if user do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      json(conn, %{token: token})
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Token non valido"})
    end
  end

  # cambio password
  def change_password(conn, %{"old_password" => old, "new_password" => new}) do
    user = Guardian.Plug.current_resource(conn)
    cond do
      user && Bcrypt.verify_pass(old, user.password_hash) ->
        case Accounts.change_user_password(user, new) do
          {:ok, _user} -> json(conn, %{message: "Password aggiornata"})
          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "Errore nell'aggiornamento", details: changeset.errors})
        end
      true ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Password attuale non corretta"})
    end
  end

  # aggiorno profilo (esempio: solo email)
  def update_profile(conn, %{"email" => email}) do
    user = Guardian.Plug.current_resource(conn)
    case Accounts.update_user(user, %{"email" => email}) do
      {:ok, user} -> json(conn, %{user: %{id: user.id, email: user.email}})
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Errore nell'aggiornamento", details: changeset.errors})
    end
  end
end
