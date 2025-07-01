import React, { useState } from 'react';
import CardList from '../components/CardList';
import Loading from '../components/Loading';
import ErrorMessage from '../components/ErrorMessage';
import { useCards, CardFilters } from '../hooks/useCards';

const Cards: React.FC = () => {
    const [filters, setFilters] = useState<CardFilters>({});

    const handleFilterChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setFilters({ ...filters, [e.target.name]: e.target.value });
    };

    const { cards, loading, error } = useCards(filters);

    return (
        <div>
            <h1>Collezione di Carte</h1>
            <div>
                <input
                    type="text"
                    name="name"
                    placeholder="Filtra per nome"
                    onChange={handleFilterChange}
                />
                <input
                    type="text"
                    name="suit"
                    placeholder="Filtra per seme"
                    onChange={handleFilterChange}
                />
            </div>
            {loading && <Loading />}
            {error && <ErrorMessage message={error} />}
            {!loading && !error && <CardList cards={cards} />}
        </div>
    );
};

export default Cards;



