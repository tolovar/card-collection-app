defmodule BackendWeb.UserController do
  use BackendWeb, :controller
  alias Backend.Accounts

  # ottengo la lista di tutti gli utenti (solo admin)
  def index(conn, _params) do
    users = Accounts.list_users()
    json(conn, %{users: users})
  end

  # ottengo un utente specifico
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    json(conn, %{user: user})
  end

  # aggiorno un utente
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    current_user = conn.assigns[:current_user]

    # controllo se sto cercando di cambiare is_admin
    if Map.has_key?(user_params, "is_admin") && !current_user.is_admin do
      # non posso cambiare is_admin
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Non sei autorizzato a promuovere admin"})
    else
      # sono admin/non sto cambiando is_admin
      case Accounts.update_user(user, user_params) do
        {:ok, user} -> json(conn, %{user: user})
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: "Errore nell'aggiornamento dell'utente"})
      end
    end
  end

  # elimino un utente (solo admin)
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    current_user = conn.assigns[:current_user]

    # controllo che non stia eliminando me stesso
    if user.id == current_user.id do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Non puoi eliminare il tuo account"})
    else
      case Accounts.delete_user(user) do
        {:ok, _user} -> json(conn, %{message: "Utente eliminato con successo"})
        {:error, _changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: "Errore nell'eliminazione dell'utente"})
      end
    end
  end
end
