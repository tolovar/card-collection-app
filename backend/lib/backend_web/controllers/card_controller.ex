defmodule BackendWeb.CardController do
  use BackendWeb, :controller

  alias Backend.Cards
  alias Backend.Cards.Card
  alias Backend.Repo

  action_fallback BackendWeb.FallbackController

  # mostro tutte le carte
  def index(conn, params) do
    cards = Backend.Cards.list_cards(params)
    cards = Repo.preload(cards, [:decks])
    render(conn, "index.json", cards: cards)
  end

  # creo una nuova carta
  def create(conn, %{"card" => card_params}) do
    with {:ok, %Card{} = card} <- Cards.create_card(card_params) do
      card = Repo.preload(card, [:decks])
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.card_path(conn, :show, card))
      |> render("show.json", card: card)
    end
  end

  # mostro una singola carta
  def show(conn, %{"id" => id}) do
    card = Cards.get_card!(id)
    card = Repo.preload(card, [:decks])
    render(conn, "show.json", card: card)
  end

  # aggiorno una carta
  def update(conn, %{"id" => id, "card" => card_params}) do
    card = Cards.get_card!(id)

    with {:ok, %Card{} = card} <- Cards.update_card(card, card_params) do
      card = Repo.preload(card, [:decks])
      render(conn, "show.json", card: card)
    end
  end

  # elimino una carta
  def delete(conn, %{"id" => id}) do
    card = Cards.get_card!(id)

    with {:ok, %Card{}} <- Cards.delete_card(card) do
      send_resp(conn, :no_content, "")
    end
  end
end
