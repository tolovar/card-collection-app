defmodule Backend.Cards.CardUtils do
  @cards [
    %{name: "asso",    value: 1,  points: 11},
    %{name: "due",     value: 2,  points: 0},
    %{name: "tre",     value: 3,  points: 10},
    %{name: "quattro", value: 4,  points: 0},
    %{name: "cinque",  value: 5,  points: 0},
    %{name: "sei",     value: 6,  points: 0},
    %{name: "sette",   value: 7,  points: 0},
    %{name: "fante",   value: 8,  points: 2},
    %{name: "cavallo", value: 9,  points: 3},
    %{name: "re",      value: 10, points: 4}
  ]

  def all_suits, do: [
    {"B", "bastoni"},
    {"C", "coppe"},
    {"D", "denari"},
    {"S", "spade"}
  ]
  def all_cards, do: @cards

  # utility per estrarre suit da id
  def suit_from_id("B" <> _), do: "bastoni"
  def suit_from_id("C" <> _), do: "coppe"
  def suit_from_id("D" <> _), do: "denari"
  def suit_from_id("S" <> _), do: "spade"
  def suit_from_id(_), do: nil

  # utility per estrarre value da id
  def value_from_id(<<_suit, rest::binary>>), do: String.to_integer(rest)
end
