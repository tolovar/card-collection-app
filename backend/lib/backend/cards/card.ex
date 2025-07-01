defmodule Backend.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "cards" do
    field :name, :string
    field :suit, :string
    field :value, :integer
    field :image_url, :string
    field :set, :string

    timestamps()
  end

  # costruisco il changeset per la carta
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :suit, :value, :image_url, :set])
    |> validate_required([:name, :suit, :value, :set])
  end

  # changeset per l'aggiornamento di una carta
  def update_changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :suit, :value, :image_url, :set])
    |> validate_required([:name, :suit, :value, :set])
  end
end
