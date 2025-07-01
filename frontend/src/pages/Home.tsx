// questo file definisce la pagina principale dell'applicazione
import React, { useEffect, useState } from 'react';
import { fetchCards } from '../api'; // importo la funzione per recuperare le carte
import CardList from '../components/CardList'; // importo il componente per visualizzare la lista delle carte

const Home: React.FC = () => {
    const [cards, setCards] = useState([]); // stato per memorizzare le carte
    const [loading, setLoading] = useState(true); // stato per gestire il caricamento

    // uso useEffect per recuperare le carte al caricamento della pagina
    useEffect(() => {
        const getCards = async () => {
            try {
                const data = await fetchCards(); // chiamo la funzione per recuperare le carte
                setCards(data); // aggiorno lo stato con i dati ricevuti
            } catch (error) {
                console.error('Errore nel recupero delle carte:', error); // gestisco eventuali errori
            } finally {
                setLoading(false); // imposto loading a false una volta completata l'operazione
            }
        };

        getCards(); // invoco la funzione per recuperare le carte
    }, []); // l'array vuoto significa che l'effetto viene eseguito solo al primo rendering

    // gestisco il caricamento
    if (loading) {
        return <div>Caricamento in corso...</div>; // messaggio di caricamento
    }

    // restituisco il componente con la lista delle carte
    return (
        <div>
            <h1>Collezione di Carte</h1>
            <CardList cards={cards} /> {/* passo le carte al componente CardList */}
        </div>
    );
};

export default Home; // esporta il componente Home per poterlo utilizzare in altre parti dell'applicazione