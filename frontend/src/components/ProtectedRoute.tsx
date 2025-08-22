import React from 'react';
import { Route, Redirect, RouteProps } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

interface ProtectedRouteProps extends RouteProps {
  adminOnly?: boolean;
  component: React.ComponentType<any>;
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ 
  adminOnly = false, 
  component: Component, 
  ...rest 
}) => {
  const { isAuthenticated, isAdmin } = useAuth();

  return (
    <Route
      {...rest}
      render={props => {
        // se non sono autenticato, reindirizzo al login
        if (!isAuthenticated) {
          return <Redirect to="/auth" />;
        }

        // se la rotta è solo per admin e non sono admin, reindirizzo alla home
        if (adminOnly && !isAdmin) {
          return <Redirect to="/" />;
        }

        // altrimenti renderizzo il componente
        return <Component {...props} />;
      }}
    />
  );
};

export default ProtectedRoute; 