defmodule BackendWeb.AuthController do
  use BackendWeb, :controller
  alias Backend.Accounts
  alias Backend.Guardian

  # registro un nuovo utente
  def register(conn, %{"email" => email, "password" => password}) do
    case Accounts.register_user(%{"email" => email, "password" => password}) do
      {:ok, user} ->
        json(conn, %{id: user.id, email: user.email})
      {:error, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "errore nella registrazione"})
    end
  end

  # effettuo il login dell'utente
  def login(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_user_by_email(email)
    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{token: token})
      true ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "credenziali non valide"})
    end
  end
end
