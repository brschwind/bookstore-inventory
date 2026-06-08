# Setup Guide

## Prerequisites

Before starting, make sure you have:

1. **Node.js** (v16 or higher)
   - Download from https://nodejs.org/
   - Verify installation: `node --version` and `npm --version`

2. **PostgreSQL** (v12 or higher)
   - Download from https://www.postgresql.org/download/
   - Verify installation: `psql --version`

3. **Git**
   - Download from https://git-scm.com/
   - Verify installation: `git --version`

4. **Square Developer Account**
   - Go to https://developer.squareup.com/
   - Create an application
   - Get your Sandbox credentials (Application ID and Access Token)

## Step-by-Step Setup

### 1. Clone the Repository

```bash
git clone https://github.com/brschwind/bookstore-inventory.git
cd bookstore-inventory
```

### 2. Set Up the Database

```bash
# Create a new database
creatdb bookstore_inventory

# Load the schema
psql bookstore_inventory < database/init.sql

# Verify it worked
psql bookstore_inventory -c "\dt"
```

### 3. Set Up the Backend

```bash
cd backend

# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Edit .env with your information
# Use your favorite editor (nano, vim, VS Code, etc.)
nano .env
```

**In .env, update:**
- `SQUARE_APPLICATION_ID` - from your Square Developer Dashboard
- `SQUARE_ACCESS_TOKEN` - from your Square Developer Dashboard
- `DATABASE_URL` - should be `postgresql://localhost/bookstore_inventory`
- `JWT_SECRET` - Keep as is (we'll change this later)

**Start the backend:**
```bash
npm run dev
```

You should see: `🚀 Server running on http://localhost:5000`

### 4. Set Up the Frontend (new terminal)

```bash
cd frontend

# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Edit .env with your application ID
nano .env
```

**Update in .env:**
- `REACT_APP_SQUARE_APPLICATION_ID` - Same as backend

**Start the frontend:**
```bash
npm start
```

Your browser should automatically open to `http://localhost:3000`

## Verify Everything Works

1. Go to http://localhost:3000
2. You should see the welcome message
3. Check the backend console - no errors?
4. Try http://localhost:5000/api/health - should see `{"status":"Server is running"}`

## Troubleshooting

### "Cannot find module" errors
```bash
# Make sure you ran npm install in both backend and frontend
npm install
```

### Database connection error
```bash
# Check PostgreSQL is running
# macOS/Linux:
psql postgres -c "SELECT 1"

# Check your connection string in .env
# Default should be: postgresql://localhost/bookstore_inventory
```

### Port already in use
```bash
# Backend port 5000 in use:
# Edit backend/.env and change PORT to 5001

# Frontend port 3000 in use:
# The frontend will ask if you want to use 3001
```

### Square API errors
- Double-check your Application ID and Access Token
- Make sure you're using Sandbox credentials (not Production)
- Verify in .env: `SQUARE_ENVIRONMENT=sandbox`

## Next Steps

Now that everything is set up, head to `/docs/ARCHITECTURE.md` to understand how the system works!
