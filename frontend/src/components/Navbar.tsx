import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

const Navbar: React.FC = () => {
  const { user, isAuthenticated, isAdmin, logout } = useAuth();
  const navigate = useNavigate();

  // funzione per gestire il logout
  const handleLogout = () => {
    logout();
    navigate('/auth');
  };

  return (
    <nav style={{
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      padding: '1rem 2rem',
      backgroundColor: '#f8f9fa',
      borderBottom: '1px solid #dee2e6'
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '2rem' }}>
        <Link to="/" style={{ textDecoration: 'none', color: '#333', fontWeight: 'bold' }}>
          Card Collection
        </Link>
        
        {isAuthenticated && (
          <>
            <Link to="/cards" style={{ textDecoration: 'none', color: '#666' }}>
              Carte
            </Link>
            <Link to="/decks" style={{ textDecoration: 'none', color: '#666' }}>
              Mazzi
            </Link>
            <Link to="/profile" style={{ textDecoration: 'none', color: '#666' }}>
              Profilo
            </Link>
          </>
        )}
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
        {isAuthenticated ? (
          <>
            {isAdmin && (
              <Link 
                to="/admin/users" 
                style={{ 
                  textDecoration: 'none', 
                  color: '#dc3545', 
                  fontWeight: 'bold',
                  padding: '0.5rem 1rem',
                  border: '1px solid #dc3545',
                  borderRadius: '4px'
                }}
              >
                Admin Panel
              </Link>
            )}
            <span style={{ color: '#666' }}>
              Ciao, {user?.email}
              {isAdmin && (
                <span style={{ 
                  marginLeft: '0.5rem', 
                  backgroundColor: '#dc3545', 
                  color: 'white', 
                  padding: '0.2rem 0.5rem', 
                  borderRadius: '3px', 
                  fontSize: '0.8rem' 
                }}>
                  ADMIN
                </span>
              )}
            </span>
            <button 
              onClick={handleLogout}
              style={{
                padding: '0.5rem 1rem',
                backgroundColor: '#6c757d',
                color: 'white',
                border: 'none',
                borderRadius: '4px',
                cursor: 'pointer'
              }}
            >
              Logout
            </button>
          </>
        ) : (
          <Link 
            to="/auth" 
            style={{
              padding: '0.5rem 1rem',
              backgroundColor: '#007bff',
              color: 'white',
              textDecoration: 'none',
              borderRadius: '4px'
            }}
          >
            Accedi
          </Link>
        )}
      </div>
    </nav>
  );
};

export default Navbar;
