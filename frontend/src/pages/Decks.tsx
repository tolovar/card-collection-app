import React, { useEffect, useState } from 'react';
import { getDecks } from '../api'; // importo la funzione per ottenere i mazzi
import DeckList from '../components/DeckList'; // importo il componente per visualizzare i mazzi

const Decks = () => {
    // definisco lo stato per i mazzi
    const [decks, setDecks] = useState([]);
    const [loading, setLoading] = useState(true); // stato per il caricamento

    // uso useEffect per ottenere i mazzi al caricamento del componente
    useEffect(() => {
        const fetchDecks = async () => {
            try {
                const response = await getDecks(); // chiamo la funzione per ottenere i mazzi
                setDecks(response.data); // aggiorno lo stato con i mazzi ricevuti
            } catch (error) {
                console.error('Errore nel recupero dei mazzi:', error); // gestisco eventuali errori
            } finally {
                setLoading(false); // imposto lo stato di caricamento a false
            }
        };

        fetchDecks(); // chiamo la funzione per ottenere i mazzi
    }, []); // l'array vuoto indica che l'effetto viene eseguito solo al primo rendering

    // gestisco il caricamento
    if (loading) {
        return <div>Caricamento in corso...</div>; // messaggio di caricamento
    }

    // restituisco il componente DeckList con i mazzi
    return (
        <div>
            <h1>Mazzi</h1>
            <DeckList decks={decks} /> {/* passo i mazzi al componente DeckList */}
        </div>
    );
};

export default Decks; // esporta il componente per l'uso in altre parti dell'applicazione