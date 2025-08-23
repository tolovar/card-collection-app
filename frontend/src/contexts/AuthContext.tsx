import React, { createContext, useContext, useState, useEffect, ReactNode, useMemo, useCallback } from 'react';
import type { User } from '../types/index';

// definisco l'interfaccia per il context dell'autenticazione
interface AuthContextType {
  user: User | null;
  token: string | null;
  login: (token: string, user: User) => void;
  logout: () => void;
  isAuthenticated: boolean;
  isAdmin: boolean;
  isLoading: boolean;
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
  const [isLoading, setIsLoading] = useState(true);

  // controllo se c'è un token salvato al caricamento dell'app
  useEffect(() => {
    const initializeAuth = () => {
      try {
        const savedToken = localStorage.getItem('token');
        const savedUser = localStorage.getItem('user');
        
        if (savedToken && savedUser) {
          const parsedUser = JSON.parse(savedUser);
          // Validazione aggiuntiva dei dati
          if (parsedUser && typeof parsedUser === 'object' && 'id' in parsedUser) {
            setToken(savedToken);
            setUser(parsedUser);
          } else {
            throw new Error('Dati utente non validi');
          }
        }
      } catch (error) {
        console.warn('Errore nell\'inizializzazione dell\'auth:', error);
        // Pulisco i dati corrotti
        localStorage.removeItem('token');
        localStorage.removeItem('user');
      } finally {
        setIsLoading(false);
      }
    };

    initializeAuth();
  }, []);

  // funzione per il login che salva token e user
  const login = useCallback((newToken: string, newUser: User) => {
    // Validazione dei parametri
    if (!newToken || typeof newToken !== 'string') {
      throw new Error('Token non valido');
    }
    if (!newUser || typeof newUser !== 'object' || !('id' in newUser)) {
      throw new Error('Dati utente non validi');
    }

    setToken(newToken);
    setUser(newUser);
    localStorage.setItem('token', newToken);
    localStorage.setItem('user', JSON.stringify(newUser));
  }, []);

  // funzione per il logout che pulisce tutto
  const logout = useCallback(() => {
    setToken(null);
    setUser(null);
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  }, []);

  // Memoizzazione del context value per evitare re-render inutili
  const value: AuthContextType = useMemo(() => ({
    user,
    token,
    login,
    logout,
    isAuthenticated: !!token && !!user,
    isAdmin: user?.is_admin || false,
    isLoading
  }), [user, token, login, logout, isLoading]);

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

// hook personalizzato per usare il context
export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth deve essere usato all\'interno di un AuthProvider');
  }
  return context;
}; 