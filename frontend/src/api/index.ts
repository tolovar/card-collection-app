import axios from 'axios';
import type { AxiosError } from 'axios';
import type { CardFilters } from '../hooks/useCards';

// definisco l'url base per le chiamate API
const API_BASE_URL = 'http://localhost:4000/api'; // modifica l'url in base alla tua configurazione

// creo un'istanza di axios per le chiamate API
const api = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json',
    },
});

// definisco l'interfaccia per i dati dell'utente
export interface UserData {
    username: string;
    email: string;
    password: string;
    // aggiungi altri campi se necessario
}

// funzione di utilità per controllare se l'errore è di tipo AxiosError
function isAxiosError(error: unknown): error is AxiosError {
    return (error as AxiosError).isAxiosError === true;
}

// funzione per registrare un nuovo utente
export const registerUser = async (userData: UserData) => {
    try {
        const response = await api.post('/users/register', userData);
        return response.data; // restituisco i dati dell'utente registrato
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante la registrazione');
        }
    }
};

// funzione per effettuare il login di un utente
export interface LoginCredentials {
    email: string;
    password: string;
}

export interface LoginResponse {
    token: string;
    user: {
        id: string;
        username: string;
        email: string;
    };
}

export const loginUser = async (credentials: LoginCredentials): Promise<LoginResponse> => {
    try {
        const response = await api.post<LoginResponse>('/users/login', credentials);
        return response.data; // restituisco i dati dell'utente loggato
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante il login');
        }
    }
};

// funzione per ottenere la lista delle carte
export const fetchCards = async (filters: CardFilters = {}): Promise<Card[]> => {
    try {
        const response = await api.get('/cards', { params: filters });
        return response.data as Card[];
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante il recupero delle carte');
        }
    }
};

// funzione per creare un nuovo mazzo
export interface DeckData {
    name: string;
    description?: string;
    cards: string[]; // array di ID delle carte
}

export interface DeckResponse {
    id: string;
    name: string;
    description?: string;
    cards: string[];
    user: string;
    createdAt: string;
    updatedAt: string;
}

export const createDeck = async (
    deckData: DeckData,
    token: string
): Promise<DeckResponse> => {
    try {
        const response = await api.post<DeckResponse>('/decks', deckData, {
            headers: {
                Authorization: `Bearer ${token}`, // invio il token per l'autenticazione
            },
        });
        // restituisco i dati del mazzo creato
        return response.data; 
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante la creazione del mazzo');
        }
    }
};

// funzione per ottenere i mazzi dell'utente
export const fetchUserDecks = async (token: string) => {
    try {
        const response = await api.get('/decks/user', {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });
        return response.data as Card[];
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante il recupero dei mazzi');
        }
    }
};

// funzione per ottenere i dettagli di un mazzo
export const fetchDeckDetails = async (deckId: string, token: string) => {
    try {
        const response = await api.get<DeckResponse>(`/decks/${deckId}`, {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });
        return response.data; 
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante il recupero dei dettagli del mazzo');
        }
    }
}

// funzione per aggiornare un mazzo
export const updateDeck = async (
    deckId: string,
    deckData: DeckData,
    token: string
): Promise<DeckResponse> => {
    try {
        const response = await api.put<DeckResponse>(`/decks/${deckId}`, deckData, {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });
        return response.data; 
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante l\'aggiornamento del mazzo');
        }
    }
}

// funzione per eliminare un mazzo
export const deleteDeck = async (deckId: string, token: string) => {
    try {
        await api.delete(`/decks/${deckId}`, {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });
        // restituisco un messaggio di successo
        return { message: 'Mazzo eliminato con successo' }; 
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            typeof error.response.data.message === 'string'
        ) {
            throw new Error(error.response.data.message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante l\'eliminazione del mazzo');
        }
    }
}

// funzione per ottenere la collezione dell'utente
export interface Card {
    id: string;
    name: string;
    description?: string;
    imageUrl?: string;
}

export const fetchUserCollection = async (token: string): Promise<Card[]> => {
    try {
        const response = await api.get('/user_cards', {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });
        return response.data as Card[]; 
    } catch (error: unknown) {
        if (
            isAxiosError(error) &&
            error.response &&
            error.response.data &&
            (error.response.data as any).message
        ) {
            throw new Error((error.response.data as any).message);
        } else if (error instanceof Error) {
            throw new Error(error.message);
        } else {
            throw new Error('errore durante il recupero della collezione utente');
        }
    }
};