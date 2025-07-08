// questo file gestisce l'autenticazione degli utenti, inclusi login e registrazione

import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/axiosConfig';
import { useAuth } from '../contexts/AuthContext';
import { User } from '../types';

const Auth: React.FC = () => {
    // stato per gestire l'email e la password
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [isLogin, setIsLogin] = useState(true); // stato per gestire login e registrazione
    const [error, setError] = useState('');
    const [isLoading, setIsLoading] = useState(false);
    const navigate = useNavigate();
    const { login } = useAuth();

    // funzione per gestire il submit del form
    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError('');
        setIsLoading(true);

        const url = isLogin ? '/api/users/login' : '/api/users/register'; // endpoint per login o registrazione

        try {
            const response = await api.post(url, { email, password });
            // controllo se la risposta è valida
            if (
                response &&
                typeof response === 'object' &&
                response.data &&
                typeof response.data === 'object' &&
                'token' in response.data &&
                typeof (response.data as any).token === 'string'
            ) {
                const token = (response.data as any).token;
                const user = (response.data as any).user as User;
                
                if (user) {
                    // uso il context per salvare i dati dell'utente
                    login(token, user);
                    navigate('/'); // reindirizzo alla home dopo il login/registrazione
                } else {
                    setError('Dati utente mancanti nella risposta.');
                }
            } else {
                setError('Risposta inattesa dal server.');
            }
        } catch (err: any) {
            // gestisco eventuali errori
            if (err.response?.data?.error) {
                setError(err.response.data.error);
            } else {
                setError('Errore durante l\'autenticazione. Riprova.');
            }
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div>
            <h2>{isLogin ? 'Login' : 'Registrazione'}</h2>
            <form onSubmit={handleSubmit}>
                <div>
                    <label>Email:</label>
                    <input
                        type="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        required
                    />
                </div>
                <div>
                    <label>Password:</label>
                    <input
                        type="password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        required
                    />
                </div>
                <button type="submit" disabled={isLoading}>
                    {isLoading ? 'Caricamento...' : (isLogin ? 'Accedi' : 'Registrati')}
                </button>
                {error && <p style={{ color: 'red' }}>{error}</p>}
            </form>
            <p>
                {isLogin ? 'Non hai un account?' : 'Hai già un account?'}
                <button onClick={() => setIsLogin(!isLogin)}>
                    {isLogin ? 'Registrati' : 'Accedi'}
                </button>
            </p>
        </div>
    );
};

export default Auth;