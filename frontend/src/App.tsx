import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Home from './pages/Home';
import Decks from './pages/Decks';
import Cards from './pages/Cards';
import Profile from './pages/Profile';
import Auth from './components/Auth';

// questo è il componente principale dell'applicazione
const App: React.FC = () => {
  return (
    <Router>
      <div>
        {/* qui gestisco la navigazione tra le pagine */}
        <Switch>
          <Route path="/" exact component={Home} />
          <Route path="/decks" component={Decks} />
          <Route path="/cards" component={Cards} />
          <Route path="/profile" component={Profile} />
          <Route path="/auth" component={Auth} />
        </Switch>
      </div>
    </Router>
  );
};

export default App;