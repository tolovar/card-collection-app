import axios from 'axios';

// dichiarazione globale per Vite
// (evita errori di tipo)
declare global {
  interface ImportMetaEnv {
    // ora funziona solo con import.meta.env.VITE_API_URL (non con process.env.REACT_APP_API_URL)
    // perché process.env non è disponibile in Vite, quindi dovrebbe risolvere il problema di index.ts
    readonly VITE_API_URL?: string;
  }
  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }
}

// TODO: valutare come impostare la variabile VITE_API_URL nel file .env per personalizzare l'URL dell'API  

// ottengo l'URL dall'env di Vite
function getApiUrl() {
  return import.meta.env.VITE_API_URL || 'http://localhost:4000';
}

// creo un'istanza di axios con configurazione di base
const api = axios.create({
  baseURL: getApiUrl(),
  headers: {
    'Content-Type': 'application/json',
  },
});

// interceptor per aggiungere automaticamente il token alle richieste
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      if (!config.headers) {
        config.headers = {};
      }
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// interceptor per gestire le risposte e gli errori
api.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    // se ricevo un 401 (non autorizzato), pulisco il token e reindirizzo al login
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/auth';
    }
    return Promise.reject(error);
  }
);

export default api; 