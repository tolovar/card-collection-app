defmodule BackendWeb.DeckController do
  use BackendWeb, :controller

  alias Backend.Decks
  alias Backend.Decks.Deck
  alias Backend.Repo

  action_fallback BackendWeb.FallbackController

  # Assegna il deck a conn.assigns per le azioni che lo richiedono
  plug :load_deck when action in [:show, :update, :delete]
  plug BackendWeb.Plugs.AuthorizeResource, resource: :deck when action in [:show, :update, :delete]

  defp load_deck(conn, _opts) do
    deck = Decks.get_deck!(conn.params["id"]) |> Repo.preload([:cards])
    assign(conn, :deck, deck)
  end

  # mostro tutti i mazzi
  def index(conn, params) do
    user = conn.assigns.current_user
    # se passo ?all=true mostro tutti i mazzi pubblici, altrimenti solo i miei
    decks =
      case params do
        %{"all" => "true"} ->
          # mostro tutti i mazzi pubblici
          Decks.list_public_decks()
        _ ->
          # mostro solo i miei mazzi (privati e pubblici)
          Decks.list_decks_by_user(user["id"])
      end
    decks = Repo.preload(decks, [:cards]) # precarico le carte dei mazzi
    render(conn, "index.json", decks: decks)
  end

  # mostro un singolo mazzo
  def show(conn, _params) do
    render(conn, "show.json", deck: conn.assigns.deck)
  end

  # creo un nuovo mazzo
  def create(conn, %{"deck" => deck_params}) do
    user = conn.assigns.current_user
    params = Map.put(deck_params, "user_id", user["id"])
    with {:ok, %Deck{} = deck} <- Decks.create_deck(params) do
      deck = Repo.preload(deck, [:cards]) # precarico le carte del mazzo appena creato
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.deck_path(conn, :show, deck))
      |> render("show.json", deck: deck)
    end
  end

  # aggiorno un mazzo
  def update(conn, %{"deck" => deck_params}) do
    with {:ok, %Deck{} = deck} <- Decks.update_deck(conn.assigns.deck, deck_params) do
      deck = Repo.preload(deck, [:cards]) # precarico le carte aggiornate
      render(conn, "show.json", deck: deck)
    end
  end

  # elimino un mazzo
  def delete(conn, _params) do
    with {:ok, %Deck{}} <- Decks.delete_deck(conn.assigns.deck) do
      send_resp(conn, :no_content, "")
    end
  end
end
