defmodule BackendWeb.DeckCardController do
  use BackendWeb, :controller

  alias Backend.Decks
  alias Backend.Decks.DeckCard

  action_fallback BackendWeb.FallbackController

  plug BackendWeb.Plugs.AuthorizeResource, resource: :deck when action in [:show, :update, :delete]

  # mostro tutte le carte nei mazzi
  def index(conn, _params) do
    deck_cards = Decks.list_deck_cards()
    render(conn, "index.json", deck_cards: deck_cards)
  end

  # aggiungo una carta a un mazzo
  def create(conn, %{"deck_card" => deck_card_params}) do
    with {:ok, %DeckCard{} = deck_card} <- Decks.create_deck_card(deck_card_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.deck_card_path(conn, :show, deck_card))
      |> render("show.json", deck_card: deck_card)
    end
  end

  # mostro una singola carta di un mazzo
  def show(conn, %{"id" => id}) do
    deck_card = Decks.get_deck_card!(id)
    render(conn, "show.json", deck_card: deck_card)
  end

  # aggiorno una carta di un mazzo
  def update(conn, %{"id" => id, "deck_card" => deck_card_params}) do
    deck_card = Decks.get_deck_card!(id)

    with {:ok, %DeckCard{} = deck_card} <- Decks.update_deck_card(deck_card, deck_card_params) do
      render(conn, "show.json", deck_card: deck_card)
    end
  end

  # elimino una carta da un mazzo
  def delete(conn, %{"id" => id}) do
    deck_card = Decks.get_deck_card!(id)

    with {:ok, %DeckCard{}} <- Decks.delete_deck_card(deck_card) do
      send_resp(conn, :no_content, "")
    end
  end
end
