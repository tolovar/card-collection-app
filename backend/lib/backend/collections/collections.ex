defmodule Backend.Collections do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Collections.UserCard

  # mostro tutte le carte della collezione personale di un utente specifico
  def list_user_cards_by_user(user_id) do
    from(uc in UserCard, where: uc.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload([:card])
  end
end
