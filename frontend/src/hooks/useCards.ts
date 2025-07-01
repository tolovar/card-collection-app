import { useEffect, useState, useRef } from 'react';
import { fetchCards } from '../api';
import { Card } from '../types';
import { debounce } from '../util/debouncer';

export interface CardFilters {
    name?: string;
    suit?: string;
    set?: string;
    [key: string]: string | undefined;
}

// questo hook gestisce il recupero delle carte, lo stato di caricamento e gli errori
export function useCards(filters: CardFilters = {}) {
    const [cards, setCards] = useState<Card[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    // uso useRef per mantenere la stessa funzione debounce tra i render
    const debouncedFetch = useRef(
        debounce(async (filters: CardFilters) => {
            setLoading(true);
            try {
                const data = await fetchCards(filters);
                setCards(data as Card[]);
                setError(null);
            } catch (err: unknown) {
                if (err instanceof Error) {
                    setError(err.message);
                } else {
                    setError('Errore nel recupero delle carte');
                }
            } finally {
                setLoading(false);
            }
        }, 400) // 400ms di debounce
    ).current;

    useEffect(() => {
        debouncedFetch(filters);
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [JSON.stringify(filters)]);

    // funzione per ricaricare le carte senza debounce
    const refresh = () => fetchCards(filters).then(setCards);

    // restituisco cards, loading ed error per l'uso nei componenti
    return { cards, loading, error, refresh };
}

export default useCards;
export type { Card }; 
export { fetchCards };