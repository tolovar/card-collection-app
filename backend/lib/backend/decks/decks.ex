defmodule Backend.Decks do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Decks.Deck

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
        order_by(query, [{^String.to_atom(dir), field(query, ^String.to_atom(field))}])
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

  def remove_card_from_deck(deck_id, card_id) do
    deck = get_deck_by_id(deck_id) |> Repo.preload(:cards)
    card = Repo.get!(Backend.Cards.Card, card_id)

    changeset = Ecto.Changeset.change(deck)
    |> Ecto.Changeset.put_assoc(:cards, List.delete(deck.cards, card))

    Repo.update(changeset)
  end

  def get_deck_by_user_id(user_id) do
    Repo.all(from d in Deck, where: d.user_id == ^user_id)
  end

end
