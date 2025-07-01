import React, { useEffect, useState } from 'react';
import { getUserProfile } from '../api'; // importo la funzione per ottenere il profilo utente
import { UserProfile } from '../types'; // importo il tipo UserProfile

const Profile: React.FC = () => {
    const [profile, setProfile] = useState<UserProfile | null>(null); // stato per il profilo utente
    const [loading, setLoading] = useState<boolean>(true); // stato per il caricamento
    const [error, setError] = useState<string | null>(null); // stato per eventuali errori

    useEffect(() => {
        const fetchProfile = async () => {
            try {
                const data = await getUserProfile(); // chiamo la funzione per ottenere il profilo
                setProfile(data); // imposto il profilo nello stato
            } catch (err) {
                setError('Errore nel caricamento del profilo'); 
            } finally {
                setLoading(false); // imposto il caricamento a false
            }
        };

        fetchProfile(); 
    }, []); // eseguo l'effetto solo al montaggio del componente

    if (loading) {
        return <div>Caricamento...</div>; 
    }

    if (error) {
        return <div>{error}</div>; 
    }

    return (
        <div>
            <h1>Profilo Utente</h1>
            {profile ? (
                <div>
                    <p>Nome: {profile.name}</p> 
                    <p>Email: {profile.email}</p> 
                </div>
            ) : (
                <p>Nessun profilo trovato.</p> 
            )}
        </div>
    );
};

export default Profile; 