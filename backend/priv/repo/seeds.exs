defmodule Backend.Repo.Seeds do
  alias Backend.Cards.CardUtils
  alias Backend.Cards
  alias Backend.Repo
  alias Backend.Accounts

  # genero tutte le combinazioni di carte da briscola siciliana
  def build_deck do
    for {suit_code, suit_name} <- CardUtils.all_suits(),
        %{name: name, value: value, points: points} <- CardUtils.all_cards() do
      %{
        id: "#{suit_code}#{value}",
        name: name,
        value: value,
        points: points,
        suit: suit_name,
        image_url: nil,
        set: "briscola_siciliana"
      }
    end
  end

  # popolo il database solo con le carte mancanti
  def seed_cards do
    deck = build_deck()
    Enum.each(deck, fn card_attrs ->
      Cards.get_card_by_id(card_attrs.id) ||
        Cards.create_card(card_attrs)
    end)
    IO.puts("Carte di briscola siciliana inserite!")
  end

  # creo un utente admin di default
  def create_admin_user do
    case Accounts.get_user_by_email("admin@example.com") do
      nil ->
        case Accounts.register_user(%{
          "email" => "admin@example.com",
          "password" => "Admin123!"
        }) do
          {:ok, user} ->
            user
            |> Ecto.Changeset.change(%{is_admin: true})
            |> Repo.update()
            IO.puts("Admin user created: admin@example.com")
          {:error, changeset} ->
            IO.puts("Error creating admin user: #{inspect(changeset.errors)}")
        end
      _user ->
        IO.puts("Admin user already exists")
    end
  end
end

# Esegui i seed
Backend.Repo.Seeds.seed_cards()
Backend.Repo.Seeds.create_admin_user()
