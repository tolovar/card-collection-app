// questo file gestisce l'autenticazione degli utenti, inclusi login e registrazione

import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

const Auth: React.FC = () => {
    // stato per gestire l'email e la password
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [isLogin, setIsLogin] = useState(true); // stato per gestire login e registrazione
    const [error, setError] = useState('');
    const navigate = useNavigate();

    // funzione per gestire il submit del form
    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError('');

        const url = isLogin ? '/api/login' : '/api/register'; // endpoint per login o registrazione

        try {
            const response = await axios.post(url, { email, password });
            // qui gestisco la risposta, ad esempio salvando il token JWT
            localStorage.setItem('token', (response.data as { token: string }).token);
            navigate('/'); // reindirizzo alla home dopo il login/registrazione
        } catch (err) {
            // gestisco eventuali errori
            setError('Errore durante l\'autenticazione. Riprova.');
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
                <button type="submit">{isLogin ? 'Accedi' : 'Registrati'}</button>
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