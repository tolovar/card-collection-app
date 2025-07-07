defmodule Backend.Repo.Seeds do
  alias Backend.Cards.CardUtils

  # automatizzo la creazione delle carte di briscola sicilian
  # creo una lista di mappe con le carte, utilizzando i dati delle funzioni di CardUtils
  # e creo le carte nel database
  def build_list do
    Enum.map(CardUtils.all_suits(), fn {suit_code, suit_name} ->
      Enum.map(CardUtils.all_names(), fn {name, value, points} ->

        %{
          id: "#{suit_code}#{value}",
          name: name,
          value: value,
          points: points,
          suit: suit_name,
          image_url: nil,
          set: "briscola_siciliana"
        }
      end)
    end)
  end

  def build_zip do
    Enum.zip(CardUtils.all_suits(), CardUtils.all_names(), CardUtilas.all_values(), CardUtils.all_points())
  end


  # pattern matching per assegnare il seme alla carta tramiet ID
  def assign_suit_bastoni("B" <> num), do: %{suit: "bastoni"}
  def assign_suit_coppe("C" <> num), do: %{suit: "coppe"}
  def assign_suit_denari("D" <> num), do: %{suit: "denari"}
  def assign_suit_spade("S" <> num), do: %{suit: "spade"}

  # pattern matching per assegnare valore numerico alla carta
  def card_value_from_name("asso"),     do: 1
  def card_value_from_name("due"),      do: 2
  def card_value_from_name("tre"),      do: 3
  def card_value_from_name("quattro"),  do: 4
  def card_value_from_name("cinque"),   do: 5
  def card_value_from_name("sei"),      do: 6
  def card_value_from_name("sette"),    do: 7
  def card_value_from_name("fante"),    do: 8
  def card_value_from_name("cavallo"),  do: 9
  def card_value_from_name("re"),       do: 10
  def card_value_from_name(_),          do: nil

  def build_deck do
    for {suit_code, suit_name} <- CardUtils.all_suits(),
        %{name: name, value: value, points: points} = card <- CardUtils.all_cards() do
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

  def suit_from_id("B" <> _), do: "bastoni"
  def suit_from_id("C" <> _), do: "coppe"
  def suit_from_id("D" <> _), do: "denari"
  def suit_from_id("S" <> _), do: "spade"
  def suit_from_id(_), do: nil

  def value_from_id(<<_suit, rest::binary>>) do
    String.to_integer(rest)
  end
end
