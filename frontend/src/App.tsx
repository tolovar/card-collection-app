import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import Navbar from './components/Navbar';
import ProtectedRoute from './components/ProtectedRoute';
import Home from './pages/Home';
import Decks from './pages/Decks';
import Cards from './pages/Cards';
import Profile from './pages/Profile';
import Auth from './components/Auth';
import AdminUsers from './pages/AdminUsers';

// questo è il componente principale dell'applicazione
const App: React.FC = () => {
  return (
    <AuthProvider>
      <Router>
        <div>
          <Navbar />
          {/* qui gestisco la navigazione tra le pagine */}
          <Switch>
            <Route path="/" exact component={Home} />
            <Route path="/auth" component={Auth} />
            <ProtectedRoute path="/decks" component={Decks} />
            <ProtectedRoute path="/cards" component={Cards} />
            <ProtectedRoute path="/profile" component={Profile} />
            <ProtectedRoute path="/admin/users" component={AdminUsers} adminOnly />
          </Switch>
        </div>
      </Router>
    </AuthProvider>
  );
};

export default App;