defmodule Backend.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "decks" do
    field :name, :string
    field :description, :string
    field :public, :boolean, default: false
    belongs_to :user, Backend.Accounts.User

    timestamps()
  end

  # costruisco il changeset per il mazzo
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:name, :description, :public, :user_id])
    |> validate_required([:name, :public, :user_id])
  end
end
