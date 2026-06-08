# Bookstore Inventory Management System

A comprehensive inventory management system for used homeschool bookstores with Square integration.

## Features

- 📚 Product catalog management with book details (ISBN, title, author, condition, price)
- 📊 Real-time inventory tracking with multiple location support
- 🔍 Advanced search and filtering capabilities
- 💰 Pricing and discount management
- 🛒 Square POS integration for sales transactions
- 👥 User management (admin and staff roles)
- 📈 Sales analytics and reporting
- ⚠️ Low stock alerts
- 📱 Mobile-friendly volunteer interface

## Tech Stack

- **Backend**: Node.js + Express
- **Frontend**: React + Tailwind CSS
- **Database**: PostgreSQL
- **Payment**: Square API
- **Hosting**: Vercel (frontend) + Railway/Render (backend)

## Project Structure

```
bookstore-inventory/
├── backend/              # Express server & API
│   ├── src/
│   │   ├── server.js     # Main server file
│   │   ├── config/       # Configuration files
│   │   ├── routes/       # API routes
│   │   ├── controllers/  # Business logic
│   │   ├── models/       # Database models
│   │   └── middleware/   # Custom middleware
│   ├── .env.example      # Environment variables template
│   └── package.json
├── frontend/             # React application
│   ├── src/
│   │   ├── App.jsx       # Main app component
│   │   ├── pages/        # Page components
│   │   ├── components/   # Reusable components
│   │   ├── styles/       # Tailwind configuration
│   │   └── utils/        # Helper functions
│   ├── .env.example
│   └── package.json
├── database/             # Database setup & migrations
│   └── init.sql          # Initial schema
└── docs/                 # Documentation
```

## Getting Started

### Prerequisites

- Node.js (v16+)
- PostgreSQL
- Square Developer Account with credentials
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/brschwind/bookstore-inventory.git
   cd bookstore-inventory
   ```

2. **Set up the backend**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Edit .env with your Square credentials and database info
   npm run dev
   ```

3. **Set up the frontend** (in a new terminal)
   ```bash
   cd frontend
   npm install
   cp .env.example .env
   # Edit .env with your backend URL
   npm start
   ```

4. **Set up the database**
   ```bash
   # Create PostgreSQL database
   createdb bookstore_inventory
   # Run initial schema
   psql bookstore_inventory < ../database/init.sql
   ```

## Environment Variables

### Backend (.env)
```
SQUARE_APPLICATION_ID=your_sandbox_app_id
SQUARE_ACCESS_TOKEN=your_sandbox_access_token
DATABASE_URL=postgresql://user:password@localhost:5432/bookstore_inventory
JWT_SECRET=your_jwt_secret_key
NODE_ENV=development
FRONTEND_URL=http://localhost:3000
```

### Frontend (.env)
```
REACT_APP_API_URL=http://localhost:5000
REACT_APP_SQUARE_APPLICATION_ID=your_sandbox_app_id
```

## Usage

### For Admins
- Manage book inventory
- Add/edit/delete products
- View sales analytics
- Manage staff accounts
- Configure pricing and discounts

### For Volunteers
- Search and filter books
- Update inventory levels
- Process sales through Square
- View daily reports

## API Documentation

See `/docs/API.md` for detailed API endpoints and usage.

## Database Schema

See `/docs/DATABASE.md` for the complete database design.

## Troubleshooting

- **Square API errors**: Verify your Application ID and Access Token are correct
- **Database connection issues**: Check PostgreSQL is running and connection string is valid
- **CORS errors**: Ensure FRONTEND_URL and backend URL are correctly configured

## Deployment

See `/docs/DEPLOYMENT.md` for instructions on deploying to production.

## Contributing

Guidelines for volunteers contributing to the project will be added soon.

## License

MIT License - feel free to use this for your bookstore.

## Support

For questions or issues, contact the project maintainer.
