import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

// creo il punto di ingresso dell'applicazione React
const root = ReactDOM.createRoot(document.getElementById('root') as HTMLElement);

// monto il componente principale dell'app
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);