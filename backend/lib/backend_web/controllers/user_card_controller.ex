defmodule BackendWeb.UserCardController do
  use BackendWeb, :controller

  alias Backend.Cards
  alias Backend.Cards.UserCard
  alias Backend.Repo

  action_fallback BackendWeb.FallbackController

  plug :load_user_card when action in [:show, :update, :delete]
  plug BackendWeb.Plugs.AuthorizeResource, resource: :user_card when action in [:show, :update, :delete]

  defp load_user_card(conn, _opts) do
    user_card = Cards.get_user_card!(conn.params["id"]) |> Repo.preload([:card])
    assign(conn, :user_card, user_card)
  end

  # mostro tutte le carte della collezione
  def index(conn, _params) do
    user = conn.assigns.current_user
    user_cards = Cards.list_user_cards_by_user(user["id"]) |> Repo.preload([:card])
    render(conn, "index.json", user_cards: user_cards)
  end

  # mostro una singola carta della collezione
  def show(conn, _params) do
    render(conn, "show.json", user_card: conn.assigns.user_card)
  end

  # aggiungo una carta alla collezione
  def create(conn, %{"user_card" => user_card_params}) do
    user = conn.assigns.current_user
    params = Map.put(user_card_params, "user_id", user["id"])
    with {:ok, %UserCard{} = user_card} <- Cards.create_user_card(params) do
      user_card = Repo.preload(user_card, [:card])
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_card_path(conn, :show, user_card))
      |> render("show.json", user_card: user_card)
    end
  end

  # aggiorno una carta della collezione
  def update(conn, %{"user_card" => user_card_params}) do
    with {:ok, %UserCard{} = user_card} <- Cards.update_user_card(conn.assigns.user_card, user_card_params) do
      user_card = Repo.preload(user_card, [:card])
      render(conn, "show.json", user_card: user_card)
    end
  end

  # elimino una carta dalla collezione
  def delete(conn, _params) do
    with {:ok, %UserCard{}} <- Cards.delete_user_card(conn.assigns.user_card) do
      send_resp(conn, :no_content, "")
    end
  end
end
