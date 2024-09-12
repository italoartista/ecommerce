#!/bin/bash

# Nome do diretório do projeto
PROJECT_NAME="ecommerce-backend"

# Criar o diretório do projeto
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Iniciar um projeto Node.js
npm init -y

# Instalar dependências necessárias
npm install express pg bcryptjs jsonwebtoken dotenv jest

# Criar estrutura de diretórios
mkdir config controllers migrations models repositories routes services

# Criar o arquivo de configuração de banco de dados
cat <<EOL > config/database.js
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

module.exports = pool;
EOL

# Criar o arquivo de exemplo .env
cat <<EOL > .env
DB_USER=seu_usuario
DB_HOST=localhost
DB_NAME=ecommerce
DB_PASSWORD=sua_senha
DB_PORT=5432
JWT_SECRET=sua_chave_secreta
EOL

# Criar o arquivo principal app.js
cat <<EOL > app.js
const express = require('express');
const app = express();
require('dotenv').config();

app.use(express.json());

// Rotas
const userRoutes = require('./routes/userRoutes');
app.use('/api/users', userRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(\`Server running on port \${PORT}\`);
});

module.exports = app;
EOL

# Criar arquivo de rotas de usuário
cat <<EOL > routes/userRoutes.js
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Rotas de usuários
router.post('/register', userController.registerUser);
router.post('/login', userController.loginUser);

module.exports = router;
EOL

# Criar arquivo de controlador de usuários
cat <<EOL > controllers/userController.js
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const userService = require('../services/userService');

// Registro de usuário
exports.registerUser = async (req, res) => {
  const { name, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  try {
    const newUser = await userService.createUser(name, email, hashedPassword);
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Login de usuário
exports.loginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const token = await userService.login(email, password);
    res.status(200).json({ token });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
EOL

# Criar arquivo de serviço de usuários
cat <<EOL > services/userService.js
const db = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Criar novo usuário
exports.createUser = async (name, email, password) => {
  const { rows } = await db.query(
    'INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING *',
    [name, email, password]
  );
  return rows[0];
};

// Login de usuário
exports.login = async (email, password) => {
  const { rows } = await db.query('SELECT * FROM users WHERE email = $1', [email]);
  const user = rows[0];
  
  if (!user) {
    throw new Error('Email não encontrado');
  }
  
  const validPassword = await bcrypt.compare(password, user.password);
  
  if (!validPassword) {
    throw new Error('Senha incorreta');
  }

  const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });
  return token;
};
EOL

# Criar arquivo de migrações para criação das tabelas
cat <<EOL > migrations/001_create_tables.sql
-- Criação da tabela users
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'client',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela categories
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela products
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  stock INTEGER DEFAULT 0,
  category_id INTEGER REFERENCES categories(id),
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela orders
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  status VARCHAR(50) DEFAULT 'pending',
  total DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela order_items
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela payments
CREATE TABLE IF NOT EXISTS payments (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  transaction_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOL

# Criar script para aplicar as migrações
cat <<EOL > applyMigrations.js
const fs = require('fs');
const path = require('path');
const db = require('./config/database');

const migrate = async () => {
  const migrationPath = path.join(__dirname, 'migrations');
  const files = fs.readdirSync(migrationPath);

  for (const file of files) {
    if (file.endsWith('.sql')) {
      const sql = fs.readFileSync(path.join(migrationPath, file), 'utf-8');
      console.log(\`Applying migration: \${file}\`);
      await db.query(sql);
    }
  }

  console.log('All migrations applied successfully.');
};

migrate().catch((err) => {
  console.error('Migration failed:', err);
});
EOL

# Finalizar a configuração
echo "Setup concluído! Execute 'node applyMigrations.js' para aplicar as migrações e iniciar o backend."
