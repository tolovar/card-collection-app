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
    |> User.registration_changeset(attrs)
    |> Repo.update()
  end

  # cerco un utente tramite email
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  # cerco un utente tramite id
  def get_user(id), do: Repo.get(User, id)
end
