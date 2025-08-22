import React, { useState, useEffect } from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";
import { User } from "../types";
import api from "../api/axiosConfig";
import Loading from "../components/Loading";

const AdminUsers: React.FC = () => {
  const { user, isAdmin } = useAuth();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // se non sono admin, reindirizzo
  if (!isAdmin) {
    return <Navigate to="/" replace />;
  }

  // carico la lista degli utenti
  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await api.get('/admin/users');
        setUsers((response.data as any).users || []);
      } catch (err: any) {
        setError(err.response?.data?.error || 'Errore nel caricamento degli utenti');
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  // funzione per promuovere/declassare un utente ad admin
  const toggleAdminStatus = async (userId: number, currentAdminStatus: boolean) => {
    try {
      await api.patch(`/admin/users/${userId}`, {
        user: { is_admin: !currentAdminStatus }
      });
      
      // aggiorno la lista degli utenti
      setUsers(users.map(u => 
        u.id === userId ? { ...u, is_admin: !currentAdminStatus } : u
      ));
    } catch (err: any) {
      setError(err.response?.data?.error || 'Errore nell\'aggiornamento');
    }
  };

  // funzione per eliminare un utente
  const deleteUser = async (userId: number) => {
    if (!window.confirm('Sei sicuro di voler eliminare questo utente?')) {
      return;
    }

    try {
      await api.delete(`/admin/users/${userId}`);
      
      // rimuovo l'utente dalla lista
      setUsers(users.filter(u => u.id !== userId));
    } catch (err: any) {
      setError(err.response?.data?.error || 'Errore nell\'eliminazione');
    }
  };

  if (loading) {
    return <Loading message="Caricamento utenti..." />;
  }

  return (
    <div style={{ padding: '2rem' }}>
      <h1>Gestione Utenti</h1>
      
      {error && (
        <div style={{ 
          padding: '1rem', 
          backgroundColor: '#f8d7da', 
          color: '#721c24', 
          borderRadius: '4px', 
          marginBottom: '1rem' 
        }}>
          {error}
        </div>
      )}

      <div style={{ overflowX: 'auto' }}>
        <table style={{ 
          width: '100%', 
          borderCollapse: 'collapse',
          backgroundColor: 'white',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <thead>
            <tr style={{ backgroundColor: '#f8f9fa' }}>
              <th style={{ padding: '1rem', textAlign: 'left', borderBottom: '1px solid #dee2e6' }}>ID</th>
              <th style={{ padding: '1rem', textAlign: 'left', borderBottom: '1px solid #dee2e6' }}>Email</th>
              <th style={{ padding: '1rem', textAlign: 'left', borderBottom: '1px solid #dee2e6' }}>Admin</th>
              <th style={{ padding: '1rem', textAlign: 'left', borderBottom: '1px solid #dee2e6' }}>Azioni</th>
            </tr>
          </thead>
          <tbody>
            {users.map(user => (
              <tr key={user.id} style={{ borderBottom: '1px solid #dee2e6' }}>
                <td style={{ padding: '1rem' }}>{user.id}</td>
                <td style={{ padding: '1rem' }}>{user.email}</td>
                <td style={{ padding: '1rem' }}>
                  <span style={{
                    padding: '0.25rem 0.5rem',
                    borderRadius: '3px',
                    fontSize: '0.8rem',
                    backgroundColor: user.is_admin ? '#d4edda' : '#f8d7da',
                    color: user.is_admin ? '#155724' : '#721c24'
                  }}>
                    {user.is_admin ? 'Sì' : 'No'}
                  </span>
                </td>
                <td style={{ padding: '1rem' }}>
                  <button
                    onClick={() => toggleAdminStatus(user.id, user.is_admin)}
                    style={{
                      marginRight: '0.5rem',
                      padding: '0.5rem 1rem',
                      backgroundColor: user.is_admin ? '#dc3545' : '#28a745',
                      color: 'white',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer'
                    }}
                  >
                    {user.is_admin ? 'Rimuovi Admin' : 'Promuovi Admin'}
                  </button>
                  <button
                    onClick={() => deleteUser(user.id)}
                    style={{
                      padding: '0.5rem 1rem',
                      backgroundColor: '#dc3545',
                      color: 'white',
                      border: 'none',
                      borderRadius: '4px',
                      cursor: 'pointer'
                    }}
                  >
                    Elimina
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminUsers;
