// questo file definisce il componente per visualizzare la collezione personale dell'utente
import React, { useEffect, useState } from 'react';
// import { fetchUserCollection } from '../api'; // importo la funzione per recuperare la collezione dell'utente
import { Card } from '../types'; // importo il tipo Card

const UserCollection: React.FC = () => {
    const [cards, setCards] = useState<Card[]>([]); // stato per memorizzare le carte dell'utente
    const [loading, setLoading] = useState<boolean>(true); // stato per gestire il caricamento
    const [error, setError] = useState<string | null>(null); // stato per gestire eventuali errori

    // recupero il token dell'utente dal localStorage (se serve autenticazione)
    const token = localStorage.getItem('token');

    // uso useEffect per recuperare la collezione dell'utente al caricamento del componente
    useEffect(() => {
        const getUserCollection = async () => {
            try {
                if (!token) {
                    setError('utente non autenticato');
                    setLoading(false);
                    return;
                }
                const userCards = await fetchUserCollection(token); // passo il token alla funzione API
                setCards(userCards); // aggiorno lo stato con le carte recuperate
            } catch (err: unknown) {
                if (err instanceof Error) {
                    setError(err.message);
                } else {
                    setError('errore nel recupero della collezione');
                }
            } finally {
                setLoading(false); // imposto il caricamento a false
            }
        };

        getUserCollection(); // invoco la funzione
    }, [token]); // eseguo solo al primo montaggio del componente

    // gestisco il caricamento
    if (loading) {
        return <div>Caricamento...</div>; // mostro un messaggio di caricamento
    }

    // gestisco eventuali errori
    if (error) {
        return <div>{error}</div>; // mostro il messaggio di errore
    }

    // renderizzo la collezione di carte
    return (
        <div>
            <h2>La mia collezione di carte</h2>
            <ul>
                {cards.map((card) => (
                    <li key={card.id}>{card.name}</li> // mostro il nome di ogni carta
                ))}
            </ul>
        </div>
    );
};

export default UserCollection; // esporta il componente per l'uso in altre parti dell'applicazione

import axios from 'axios';


// Funzione per recuperare la collezione personale dell'utente
export async function fetchUserCollection(token: string): Promise<Card[]> {
    // Sostituisci l'URL con quello effettivo della tua API backend
    const response = await axios.get('/api/user/collection', {
        headers: {
            Authorization: `Bearer ${token}`,
        },
    });
    return response.data as Card[];
}