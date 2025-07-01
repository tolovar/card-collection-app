// questo file definisce il componente per costruire e gestire i mazzi
import React, { useState, useEffect } from 'react';
import { fetchCards, createDeck } from '../api'; // importo le funzioni per le chiamate API

const DeckBuilder: React.FC = () => {
    // definisco lo stato per le carte e il mazzo
    const [cards, setCards] = useState<any[]>([]);
    const [deckName, setDeckName] = useState<string>('');
    const [selectedCards, setSelectedCards] = useState<any[]>([]);

    // uso useEffect per caricare le carte all'avvio del componente
    useEffect(() => {
        const loadCards = async () => {
            const fetchedCards = await fetchCards(); // chiamo la funzione per ottenere le carte
            setCards(fetchedCards as any[]); // aggiorno lo stato con le carte ottenute
        };
        loadCards(); // eseguo la funzione di caricamento
    }, []);

    // funzione per gestire la selezione delle carte
    const toggleCardSelection = (card: any) => {
        if (selectedCards.includes(card)) {
            setSelectedCards(selectedCards.filter(c => c !== card)); // rimuovo la carta se già selezionata
        } else {
            setSelectedCards([...selectedCards, card]); // aggiungo la carta se non è selezionata
        }
    };

    // funzione per gestire la creazione del mazzo
    const handleCreateDeck = async () => {
        if (deckName.trim() === '' || selectedCards.length === 0) {
            alert('devi inserire un nome per il mazzo e selezionare almeno una carta'); // controllo input
            return;
        }
        // TODO: rimpiazzare 'tuoToken' col valore giusto, probabilmente preso da context o props
        await createDeck({ name: deckName, cards: selectedCards }, 'tuoToken'); // chiamo la funzione per creare il mazzo
        alert('mazzo creato con successo!'); // messaggio di successo
        setDeckName(''); // resetto il nome del mazzo
        setSelectedCards([]); // resetto le carte selezionate
    };

    return (
        <div>
            <h2>Costruisci il tuo mazzo</h2>
            <input 
                type="text" 
                value={deckName} 
                onChange={(e) => setDeckName(e.target.value)} 
                placeholder="Nome del mazzo" 
            />
            <div>
                <h3>Seleziona le carte:</h3>
                {cards.map(card => (
                    <div key={card.id}>
                        <input 
                            type="checkbox" 
                            checked={selectedCards.includes(card)} 
                            onChange={() => toggleCardSelection(card)} 
                        />
                        {card.name} {/* visualizzo il nome della carta */}
                    </div>
                ))}
            </div>
            <button onClick={handleCreateDeck}>Crea Mazzo</button> {/* bottone per creare il mazzo */}
        </div>
    );
};

export default DeckBuilder; // esporta il componente per l'uso in altre parti dell'applicazione