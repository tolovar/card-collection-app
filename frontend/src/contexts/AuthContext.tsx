import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { User } from '../types';

// definisco l'interfaccia per il context dell'autenticazione
interface AuthContextType {
  user: User | null;
  token: string | null;
  login: (token: string, user: User) => void;
  logout: () => void;
  isAuthenticated: boolean;
  isAdmin: boolean;
}

// creo il context con un valore di default
const AuthContext = createContext<AuthContextType | undefined>(undefined);

// props per il provider
interface AuthProviderProps {
  children: ReactNode;
}

// provider del context che gestisce lo stato dell'autenticazione
export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);

  // controllo se c'è un token salvato al caricamento dell'app
  useEffect(() => {
    const savedToken = localStorage.getItem('token');
    const savedUser = localStorage.getItem('user');
    
    if (savedToken && savedUser) {
      try {
        const parsedUser = JSON.parse(savedUser);
        setToken(savedToken);
        setUser(parsedUser);
      } catch (error) {
        // se il parsing fallisce, pulisco i dati corrotti
        localStorage.removeItem('token');
        localStorage.removeItem('user');
      }
    }
  }, []);

  // funzione per il login che salva token e user
  const login = (newToken: string, newUser: User) => {
    setToken(newToken);
    setUser(newUser);
    localStorage.setItem('token', newToken);
    localStorage.setItem('user', JSON.stringify(newUser));
  };

  // funzione per il logout che pulisce tutto
  const logout = () => {
    setToken(null);
    setUser(null);
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  };

  // calcolo se l'utente è autenticato
  const isAuthenticated = !!token && !!user;
  
  // calcolo se l'utente è admin
  const isAdmin = user?.is_admin || false;

  const value: AuthContextType = {
    user,
    token,
    login,
    logout,
    isAuthenticated,
    isAdmin
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

// hook personalizzato per usare il context
export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth deve essere usato all\'interno di un AuthProvider');
  }
  return context;
}; 