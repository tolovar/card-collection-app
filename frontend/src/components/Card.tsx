import React from 'react';

// definisco il tipo Card (puoi importarlo se già definito altrove)
type Card = {
    id: number;
    name: string;
};

interface CardProps {
    card: Card;
}

const Card: React.FC<CardProps> = ({ card }) => (
    <div>
        <h3>{card.name}</h3>
        {/* altri dettagli della carta */}
    </div>
);

export default Card;