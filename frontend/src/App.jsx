import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

// TODO: Import pages as they are created
// import Dashboard from './pages/Dashboard';
// import Inventory from './pages/Inventory';
// import Sales from './pages/Sales';
// import Settings from './pages/Settings';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-50">
        {/* TODO: Add navigation header */}
        <Routes>
          <Route path="/" element={
            <div className="flex items-center justify-center h-screen">
              <div className="text-center">
                <h1 className="text-4xl font-bold mb-4">📚 Bookstore Inventory</h1>
                <p className="text-xl text-gray-600">Welcome! More pages coming soon...</p>
              </div>
            </div>
          } />
          {/* TODO: Add more routes */}
        </Routes>
      </div>
    </Router>
  );
}

export default App;
