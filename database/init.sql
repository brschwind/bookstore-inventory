-- Bookstore Inventory Database Schema

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  role VARCHAR(50) NOT NULL DEFAULT 'staff', -- 'admin' or 'staff'
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Categories table
CREATE TABLE product_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Types table (with standard pricing)
CREATE TABLE product_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id UUID NOT NULL REFERENCES product_categories(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  standard_price DECIMAL(10, 2) NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(category_id, name)
);

-- Books table
CREATE TABLE books (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  isbn VARCHAR(13),
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255),
  publisher VARCHAR(255),
  publication_year INTEGER,
  description TEXT,
  pages INTEGER,
  product_type_id UUID REFERENCES product_types(id),
  condition VARCHAR(50), -- 'like_new', 'very_good', 'good', 'fair', 'poor'
  cost_price DECIMAL(10, 2),
  sale_price DECIMAL(10, 2) NOT NULL,
  square_catalog_object_id VARCHAR(255), -- Link to Square catalog
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory Locations table
CREATE TABLE inventory_locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory table
CREATE TABLE inventory (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  book_id UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  location_id UUID NOT NULL REFERENCES inventory_locations(id) ON DELETE CASCADE,
  quantity_on_hand INTEGER NOT NULL DEFAULT 0,
  quantity_reserved INTEGER NOT NULL DEFAULT 0,
  last_count_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(book_id, location_id)
);

-- Sales/Transactions table
CREATE TABLE sales (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  square_transaction_id VARCHAR(255) UNIQUE,
  amount DECIMAL(10, 2) NOT NULL,
  payment_method VARCHAR(50), -- 'cash', 'card', 'online'
  customer_name VARCHAR(255),
  customer_email VARCHAR(255),
  staff_id UUID REFERENCES users(id),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sales Items table (individual books in a sale)
CREATE TABLE sale_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sale_id UUID NOT NULL REFERENCES sales(id) ON DELETE CASCADE,
  book_id UUID NOT NULL REFERENCES books(id),
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL,
  discount_amount DECIMAL(10, 2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Discounts table
CREATE TABLE discounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  discount_type VARCHAR(50), -- 'percentage' or 'fixed_amount'
  discount_value DECIMAL(10, 2) NOT NULL,
  min_purchase DECIMAL(10, 2),
  max_discount DECIMAL(10, 2),
  is_active BOOLEAN DEFAULT true,
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit log for inventory changes
CREATE TABLE audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  action VARCHAR(100) NOT NULL, -- 'add', 'update', 'delete', 'adjust_quantity'
  entity_type VARCHAR(50) NOT NULL, -- 'book', 'inventory', 'sale'
  entity_id UUID NOT NULL,
  old_values JSONB,
  new_values JSONB,
  performed_by UUID REFERENCES users(id),
  ip_address VARCHAR(45),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_product_type ON books(product_type_id);
CREATE INDEX idx_inventory_book_id ON inventory(book_id);
CREATE INDEX idx_inventory_location_id ON inventory(location_id);
CREATE INDEX idx_sales_created_at ON sales(created_at);
CREATE INDEX idx_sale_items_sale_id ON sale_items(sale_id);
CREATE INDEX idx_audit_log_entity ON audit_log(entity_type, entity_id);

-- Insert product categories
INSERT INTO product_categories (name, description) VALUES
('Reading', 'Books for reading'),
('Media', 'DVDs, Videos, and other media'),
('Supplements', 'Educational supplements, games, and manipulatives'),
('Textbooks & Teacher', 'Textbooks and teacher resources'),
('Workbooks (Consumable)', 'Workbooks and consumable materials');

-- Insert product types with standard pricing
INSERT INTO product_types (category_id, name, standard_price) VALUES
((SELECT id FROM product_categories WHERE name = 'Media'), 'DVD (Education/Movies)', 5.00),
((SELECT id FROM product_categories WHERE name = 'Reading'), 'Dollar', 1.00),
((SELECT id FROM product_categories WHERE name = 'Reading'), 'Picture Book', 2.00),
((SELECT id FROM product_categories WHERE name = 'Reading'), 'Readers (Early)', 0.50),
((SELECT id FROM product_categories WHERE name = 'Reading'), 'Reading Book', 4.00),
((SELECT id FROM product_categories WHERE name = 'Reading'), 'Reading Book (Premium)', 6.00),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Flashcards', 0.50),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Games', 5.00),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Kit (Science)', 25.00),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Kit (Premium)', 50.00),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Manipulatives (Large)', 10.00),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Manipulatives (Small)', 5.00),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Reference/Skill Books (Premium)', 6.00),
((SELECT id FROM product_categories WHERE name = 'Supplements'), 'Reference/Skill Books', 3.00),
((SELECT id FROM product_categories WHERE name = 'Textbooks & Teacher'), 'Answer Key', 1.00),
((SELECT id FROM product_categories WHERE name = 'Textbooks & Teacher'), 'Picture Book (Premium)', 5.00),
((SELECT id FROM product_categories WHERE name = 'Textbooks & Teacher'), 'Textbook (Hardcover)', 10.00),
((SELECT id FROM product_categories WHERE name = 'Textbooks & Teacher'), 'Textbook (Premium)', 15.00),
((SELECT id FROM product_categories WHERE name = 'Textbooks & Teacher'), 'Textbook (Softcover)', 5.00),
((SELECT id FROM product_categories WHERE name = 'Workbooks (Consumable)'), 'Box Set', 25.00),
((SELECT id FROM product_categories WHERE name = 'Workbooks (Consumable)'), 'Box Set (Premium)', 40.00),
((SELECT id FROM product_categories WHERE name = 'Workbooks (Consumable)'), 'Workbook - Full year/curriculum', 8.00),
((SELECT id FROM product_categories WHERE name = 'Workbooks (Consumable)'), 'Workbook - Premium', 12.00),
((SELECT id FROM product_categories WHERE name = 'Workbooks (Consumable)'), 'Workbook - Small', 2.00);

-- Insert default inventory location
INSERT INTO inventory_locations (name, description) VALUES
('Main Storage', 'Primary storage location');
