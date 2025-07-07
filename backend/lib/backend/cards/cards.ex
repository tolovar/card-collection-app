defmodule Backend.Cards do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Cards.Card

  # ricerca avanzata, filtri, paginazione e ordinamento
  def list_cards(opts \\ %{}) do
    Card
    |> apply_filters(opts)
    |> apply_order(opts)
    |> apply_pagination(opts)
    |> Repo.all()
  end

  defp apply_filters(query, opts) do
    query
    |> maybe_filter(:name, opts)
    |> maybe_filter(:suit, opts)
    |> maybe_filter(:set, opts)
    # poi aggiungerò i tag ( |> maybe_filter(:tags, opts) )
  end

  defp maybe_filter(query, field, opts) do
    case Map.get(opts, Atom.to_string(field)) do
      nil -> query
      value -> where(query, [c], field(c, ^field) == ^value)
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

  def get_card_by_id(id) do
    Repo.get(Card, id)
  end

  def get_card_by_name(name) do
    Repo.get_by(Card, name: name)
  end

  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  def update_card(%Card{} = card, attrs) do
    card
    |> Card.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end


end
