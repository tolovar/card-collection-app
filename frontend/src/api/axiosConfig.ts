import axios from 'axios';

// creo un'istanza di axios con configurazione di base
const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL || 'http://localhost:4000',
  headers: {
    'Content-Type': 'application/json',
  },
});

// interceptor per aggiungere automaticamente il token alle richieste
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
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