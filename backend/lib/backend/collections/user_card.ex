defmodule Backend.Collections.UserCard do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_cards" do
    belongs_to :user, Backend.Accounts.User
    belongs_to :card, Backend.Cards.Card

    timestamps()
  end

  # changeset per la collezione dell'utente
  def changeset(user_card, attrs) do
    user_card
    |> cast(attrs, [:user_id, :card_id])
    |> validate_required([:user_id, :card_id])
    |> unique_constraint([:user_id, :card_id])
  end

  # changeset per l'aggiornamento della collezione dell'utente
  def update_changeset(user_card, attrs) do
    user_card
    |> cast(attrs, [:user_id, :card_id])
    |> validate_required([:user_id, :card_id])
    |> unique_constraint([:user_id, :card_id])
  end

  # changeset per la rimozione della collezione dell'utente
  def delete_changeset(user_card) do
    user_card
    |> cast(%{}, [])
  end
end
