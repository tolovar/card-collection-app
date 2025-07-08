defmodule Backend.Accounts do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Accounts.User

  # creo un nuovo utente usando il changeset di registrazione
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # aggiorno un utente esistente
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  # cerco un utente tramite email
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  # cerco un utente tramite id
  def get_user(id), do: Repo.get(User, id)

  # cerco un utente tramite id (con ! per errore se non trovato)
  def get_user!(id), do: Repo.get!(User, id)

  # ottengo la lista di tutti gli utenti
  def list_users do
    Repo.all(User)
  end

  # elimino un utente
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
