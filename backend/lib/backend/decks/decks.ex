defmodule Backend.Decks do
  @moduledoc """
  gestisco le operazioni sui mazzi di carte.
  implemento funzioni per creare, modificare, eliminare e cercare mazzi.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Decks.Deck

  def remove_card_from_deck(deck_id, card_id) do
    deck = get_deck_by_id(deck_id) |> Repo.preload(:cards)
    card = Repo.get!(Backend.Cards.Card, card_id)

    changeset = Ecto.Changeset.change(deck)
    |> Ecto.Changeset.put_assoc(:cards, deck.cards -- [card])

    Repo.update(changeset)
  end

  # funzioni di supporto per il cache manager

  # recupero i mazzi di un utente con filtri personalizzabili (cache)
  def list_decks_by_user(user_id, opts \\ %{}) do
    Deck
    |> where([d], d.user_id == ^user_id)
    |> apply_filters(opts)
    |> apply_order(opts)
    |> apply_pagination(opts)
    |> Repo.all()
  end

  # conto i mazzi totali di un utente per le statistiche
  def count_user_decks(user_id) do
    from(d in Deck, where: d.user_id == ^user_id)
    |> Repo.aggregate(:count, :id)
  end

  # conto solo i mazzi pubblici di un utente per le statistiche
  def count_public_decks_by_user(user_id) do
    from(d in Deck, where: d.user_id == ^user_id and d.public == true)
    |> Repo.aggregate(:count, :id)
  end

  # trovo tutti i mazzi che contengono una carta specifica per l'invalidazione cache
  def get_decks_containing_card(card_id) do
    from(d in Deck,
      join: c in assoc(d, :cards),
      where: c.id == ^card_id,
      select: d
    )
    |> Repo.all()
  end

  def list_decks(opts \\ %{}) do
    Deck
    |> apply_filters(opts)
    |> apply_order(opts)
    |> apply_pagination(opts)
    |> Repo.all()
  end

  defp apply_filters(query, opts) do
    query
    |> maybe_filter(:name, opts)
    |> maybe_filter(:public, opts)
    |> maybe_filter(:user_id, opts)
    # poi aggiungerò i tag ( |> maybe_filter(:tags, opts) )
  end

  defp maybe_filter(query, field, opts) do
    case Map.get(opts, Atom.to_string(field)) do
      nil -> query
      value -> where(query, [d], field(d, ^field) == ^value)
    end
  end

  defp apply_order(query, opts) do
    case Map.get(opts, "order_by") do
      nil -> query
      field ->
        dir = Map.get(opts, "order_dir", "asc")
        order_by(query, [{^String.to_atom(dir), ^String.to_atom(field)}])
    end
  end

  defp apply_pagination(query, opts) do
    page = Map.get(opts, "page", "1") |> String.to_integer()
    page_size = Map.get(opts, "page_size", "20") |> String.to_integer()
    offset = (page - 1) * page_size
    query |> limit(^page_size) |> offset(^offset)
  end

  def get_deck_by_id(id) do
    Repo.get(Deck, id)
  end

  def get_deck!(id) do
    Repo.get!(Deck, id)
  end

  def get_deck_by_name(name) do
    Repo.get_by(Deck, name: name)
  end

  def create_deck(attrs \\ %{}) do
    %Deck{}
    |> Deck.changeset(attrs)
    |> Repo.insert()
  end

  def update_deck(%Deck{} = deck, attrs) do
    deck
    |> Deck.changeset(attrs)
    |> Repo.update()
  end

  def delete_deck(%Deck{} = deck) do
    Repo.delete(deck)
  end

  def get_deck_cards(deck_id) do
    from(d in Deck,
      join: c in assoc(d, :cards),
      where: d.id == ^deck_id,
      select: c
    )
    |> Repo.all()
  end

  def add_card_to_deck(deck_id, card_id) do
    deck = get_deck_by_id(deck_id) |> Repo.preload(:cards)
    card = Repo.get!(Backend.Cards.Card, card_id)

    changeset = Ecto.Changeset.change(deck)
    |> Ecto.Changeset.put_assoc(:cards, [card | deck.cards])

    Repo.update(changeset)
  end

  def get_deck_by_user_id(user_id) do
    Repo.all(from d in Deck, where: d.user_id == ^user_id)
  end

  def list_public_decks(opts \\ %{}) do
    Deck
    |> where([d], d.public == true)
    |> apply_filters(opts)
    |> apply_order(opts)
    |> apply_pagination(opts)
    |> Repo.all()
  end
end
