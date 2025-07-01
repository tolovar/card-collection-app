// questo file definisce i tipi TypeScript utilizzati nell'applicazione

// definisco un'interfaccia per rappresentare una carta
export interface Card {
    id: string; // uso string se il backend restituisce UUID, altrimenti number
    name: string;
    description?: string;
    imageUrl?: string;
}

// definisco un'interfaccia per rappresentare un mazzo
export interface Deck {
    id: number; // identificatore unico del mazzo
    name: string; // nome del mazzo
    cards: Card[]; // array di carte che compongono il mazzo
    isPublic: boolean; // flag per indicare se il mazzo è pubblico
}

// definisco un'interfaccia per rappresentare un utente
export interface User {
    id: number; // identificatore unico dell'utente
    username: string; // nome utente
    email: string; // email dell'utente
    collections: Card[]; // collezione personale di carte dell'utente
}

// definisco un'interfaccia per rappresentare la risposta dell'API per le carte
export interface CardResponse {
    cards: Card[]; // array di carte restituito dall'API
}

// definisco un'interfaccia per rappresentare la risposta dell'API per i mazzi
export interface DeckResponse {
    decks: Deck[]; // array di mazzi restituito dall'API
}

// definisco un'interfaccia per rappresentare la risposta dell'API per gli utenti
export interface UserResponse {
    users: User[]; // array di utenti restituito dall'API
}