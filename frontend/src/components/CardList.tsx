// questo file definisce il componente per visualizzare la lista delle carte

import React, { useEffect, useState } from 'react';
import { Card } from '../types';

interface CardListProps {
    cards: Card[];
}

const CardList: React.FC<CardListProps> = ({ cards }) => (
    <ul>
        {cards.map(card => (
            <li key={card.id}>{card.name}</li>
        ))}
    </ul>
);

export default CardList; 