# metto a mano le carte di briscola, poi è da valutare come fare
cards = [
  %{id: "B1",name: "asso", suit: "bastoni", points: 11, image_url: nil, set: "briscola_siciliana"},
  %{id: "B2",name: "due", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "B3",name: "tre", suit: "bastoni", points: 10, image_url: nil, set: "briscola_siciliana"},
  %{id: "B4",name: "quattro", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "B5",name: "cinque", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "B6",name: "sei", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "B7",name: "sette", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "B8",name: "fante", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "B9",name: "cavallo", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "B10",name: "re", suit: "bastoni", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "C1",name: "asso", suit: "coppe", points: 11, image_url: nil, set: "briscola_siciliana"},
  %{id: "C2",name: "due", suit: "coppe", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "C3",name: "tre", suit: "coppe", points: 10, image_url: nil, set: "briscola_siciliana"},
  %{id: "C4",name: "quattro", suit: "coppe", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "C5",name: "cinque", suit: "coppe", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "C6",name: "sei", suit: "coppe", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "C7",name: "sette", suit: "coppe", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "C8",name: "fante", suit: "coppe", points: 2, image_url: nil, set: "briscola_siciliana"},
  %{id: "C9",name: "cavallo", suit: "coppe", points: 3, image_url: nil, set: "briscola_siciliana"},
  %{id: "C10",name: "re", suit: "coppe", points: 4, image_url: nil, set: "briscola_siciliana"},
  %{id: "D1",name: "asso", suit: "denari", points: 11, image_url: nil, set: "briscola_siciliana"},
  %{id: "D2",name: "due", suit: "denari", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "D3",name: "tre", suit: "denari", points: 10, image_url: nil, set: "briscola_siciliana"},
  %{id: "D4",name: "quattro", suit: "denari", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "D5",name: "cinque", suit: "denari", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "D6",name: "sei", suit: "denari", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "D7",name: "sette", suit: "denari", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "D8",name: " fante", suit: "denari", points: 2, image_url: nil, set: "briscola_siciliana"},
  %{id: "D9",name: "cavallo", suit: "denari", points: 3, image_url: nil, set: "briscola_siciliana"},
  %{id: "D10",name: "re", suit: "denari", points: 4, image_url: nil, set: "briscola_siciliana"},
  %{id: "S1",name: "asso", suit: "spade", points: 11, image_url: nil, set: "briscola_siciliana"},
  %{id: "S2",name: "due", suit: "spade", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "S3",name: "tre", suit: "spade", points: 10, image_url: nil, set: "briscola_siciliana"},
  %{id: "S4",name: "quattro", suit: "spade", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "S5",name: "cinque", suit: "spade", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "S6",name: "sei", suit: "spade", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "S7",name: "sette", suit: "spade", points: 0, image_url: nil, set: "briscola_siciliana"},
  %{id: "S8",name: "fante", suit: "spade", points: 2, image_url: nil, set: "briscola_siciliana"},
  %{id: "S9",name: "cavallo", suit: "spade", points: 3, image_url: nil, set: "briscola_siciliana"},
  %{id: "S10",name: "re", suit: "spade", points: 4, image_url: nil, set: "briscola_siciliana"}
]
Enum.each(cards, fn card -> Backend.Cards.create_card(card) end)


# pattern matching per assegnare il seme alla carta tramiet ID
def assign_suit_bastoni("B" <> num), do: %{suit: "bastoni"}
def assign_suit_coppe("C" <> num), do: %{suit: "coppe"}
def assign_suit_denari("D" <> num), do: %{suit: "denari"}
def assign_suit_spade("S" <> num), do: %{suit: "spade"}

def data do
  %{
    "cards" => Backend.Cards.list_cards(),
  }
end

defp assign_set
