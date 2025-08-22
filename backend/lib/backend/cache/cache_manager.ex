defmodule Backend.Cache.CacheManager do

  # gestisco il sistema di cache multi-livello per ottimizzare le performance.
  # implemento strategie di cache intelligenti con TTL dinamici e invalidazione automatica.


  use GenServer
  require Logger

  alias Backend.Repo

  # cache TTL in secondi
  @default_ttl 3600  # 1 ora
  @user_cache_ttl 1800  # 30 minuti
  @card_cache_ttl 7200  # 2 ore (carte cambiano poco)
  @deck_cache_ttl 900   # 15 minuti (mazzi cambiano più spesso)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    # inizializzo le tabelle ETS per cache locale
    :ets.new(:cards_cache, [:named_table, :public, read_concurrency: true])
    :ets.new(:decks_cache, [:named_table, :public, read_concurrency: true])
    :ets.new(:users_cache, [:named_table, :public, read_concurrency: true])

    # schedule cleanup periodico
    schedule_cleanup()

    {:ok, %{}}
  end

  # API pubblica


  # recupero una carta dal cache o dal database

  def get_card(card_id) do
    cache_key = "card:#{card_id}"

    case get_from_cache(:cards_cache, cache_key) do
      {:hit, card} ->
        Logger.debug("Cache hit for card #{card_id}")
        card
      :miss ->
        Logger.debug("Cache miss for card #{card_id}")
        card = Backend.Cards.get_card!(card_id) |> Repo.preload([:decks])
        put_in_cache(:cards_cache, cache_key, card, @card_cache_ttl)
        card
    end
  end

  # recupero i mazzi di un utente con cache intelligente

  def get_user_decks(user_id, opts \\ %{}) do
    # Cache diversificata per opzioni di query
    cache_key = "user_decks:#{user_id}:#{hash_opts(opts)}"

    case get_from_cache(:decks_cache, cache_key) do
      {:hit, decks} ->
        Logger.debug("Cache hit for user decks #{user_id}")
        decks
      :miss ->
        Logger.debug("Cache miss for user decks #{user_id}")
        decks = Backend.Decks.list_decks_by_user(user_id, opts) |> Repo.preload([:cards])
        put_in_cache(:decks_cache, cache_key, decks, @deck_cache_ttl)
        decks
    end
  end

  # recupero le statistiche utente con cache aggressivo
  def get_user_stats(user_id) do
    cache_key = "user_stats:#{user_id}"

    case get_from_cache(:users_cache, cache_key) do
      {:hit, stats} -> stats
      :miss ->
        stats = calculate_user_stats(user_id)
        put_in_cache(:users_cache, cache_key, stats, @user_cache_ttl)
        stats
    end
  end

  # invalido cache quando un utente modifica i suoi mazzi
  def invalidate_user_cache(user_id) do
    pattern = "user_decks:#{user_id}:*"
    invalidate_pattern(:decks_cache, pattern)
    invalidate_pattern(:users_cache, "user_stats:#{user_id}")

    # notifico altri nodi nel cluster (se distribuito)
    Phoenix.PubSub.broadcast(Backend.PubSub, "cache_invalidation", {:invalidate_user, user_id})
  end

  # invalida cache quando una carta viene modificata
  def invalidate_card_cache(card_id) do
    invalidate_pattern(:cards_cache, "card:#{card_id}")
    # invalida anche i mazzi che contengono questa carta
    invalidate_decks_with_card(card_id)
  end

  # funzioni private

  defp get_from_cache(table, key) do
    case :ets.lookup(table, key) do
      [{^key, value, expiry}] ->
        if :os.system_time(:second) < expiry do
          {:hit, value}
        else
          :ets.delete(table, key)
          :miss
        end
      [] -> :miss
    end
  end

  defp put_in_cache(table, key, value, ttl) do
    expiry = :os.system_time(:second) + ttl
    :ets.insert(table, {key, value, expiry})
    :ok
  end

  defp invalidate_pattern(table, pattern) do
    keys = :ets.match(table, {:"$1", :_, :_})
    |> List.flatten()
    |> Enum.filter(&String.match?(to_string(&1), ~r/#{pattern}/))

    Enum.each(keys, &:ets.delete(table, &1))
  end

  defp hash_opts(opts) do
    opts
    |> Enum.sort()
    |> :erlang.phash2()
  end

  defp calculate_user_stats(user_id) do
    %{
      total_cards: count_user_cards(user_id),
      total_decks: count_user_decks(user_id),
      public_decks: count_public_decks(user_id),
      favorite_suit: get_favorite_suit(user_id)
    }
  end

  defp count_user_cards(user_id) do
    Backend.Cards.count_user_cards(user_id)
  end

  defp count_user_decks(user_id) do
    Backend.Decks.count_user_decks(user_id)
  end

  defp count_public_decks(user_id) do
    Backend.Decks.count_public_decks_by_user(user_id)
  end

  defp get_favorite_suit(user_id) do
    Backend.Cards.get_most_collected_suit(user_id)
  end

  defp invalidate_decks_with_card(card_id) do
    # query per trovare mazzi che contengono questa carta
    # e invalidare la loro cache
    Backend.Decks.get_decks_containing_card(card_id)
    |> Enum.each(fn deck ->
      invalidate_pattern(:decks_cache, "user_decks:#{deck.user_id}:*")
    end)
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, :timer.minutes(30))
  end

  @impl true
  def handle_info(:cleanup, state) do
    Logger.info("Running cache cleanup")
    cleanup_expired_entries()
    schedule_cleanup()
    {:noreply, state}
  end

  defp cleanup_expired_entries do
    current_time = :os.system_time(:second)

    [:cards_cache, :decks_cache, :users_cache]
    |> Enum.each(fn table ->
      expired_keys = :ets.match(table, {:"$1", :_, :"$3"})
      |> Enum.filter(fn [_, _, expiry] -> current_time >= expiry end)
      |> Enum.map(fn [key, _, _] -> key end)

      Enum.each(expired_keys, &:ets.delete(table, &1))

      if length(expired_keys) > 0 do
        Logger.debug("Cleaned #{length(expired_keys)} expired entries from #{table}")
      end
    end)
  end
end
