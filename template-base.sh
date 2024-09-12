#!/bin/bash

# Criando a estrutura de diretórios
mkdir -p ecommerce-backend/{config,controllers,services,repositories,models,routes,middlewares,utils,migrations,tests,public}

# Arquivos básicos
touch ecommerce-backend/.env
touch ecommerce-backend/app.js
touch ecommerce-backend/config/database.js
touch ecommerce-backend/routes/index.js

# Criando arquivos de exemplo
echo "// Express app setup" > ecommerce-backend/app.js
echo "const express = require('express');
const app = express();
const routes = require('./routes');
const db = require('./config/database');

// Middlewares
app.use(express.json());

// Routes
app.use('/api', routes);

// Server initialization
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(\`Server running on port \${PORT}\`);
});

module.exports = app;
" > ecommerce-backend/app.js

echo "// Database connection setup" > ecommerce-backend/config/database.js
echo "const { Pool } = require('pg');
const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};
" > ecommerce-backend/config/database.js

echo "// Index route" > ecommerce-backend/routes/index.js
echo "const express = require('express');
const router = express.Router();
const userRoutes = require('./users');

// Define routes
router.use('/users', userRoutes);

module.exports = router;
" > ecommerce-backend/routes/index.js

echo "// Example controller" > ecommerce-backend/controllers/userController.js
echo "const userService = require('../services/userService');

exports.getUsers = async (req, res) => {
  try {
    const users = await userService.getAllUsers();
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
};
" > ecommerce-backend/controllers/userController.js

echo "// Example service" > ecommerce-backend/services/userService.js
echo "const userRepository = require('../repositories/userRepository');

exports.getAllUsers = async () => {
  return await userRepository.getUsers();
};
" > ecommerce-backend/services/userService.js

echo "// Example repository" > ecommerce-backend/repositories/userRepository.js
echo "const db = require('../config/database');

exports.getUsers = async () => {
  const result = await db.query('SELECT * FROM users');
  return result.rows;
};
" > ecommerce-backend/repositories/userRepository.js

# Permissions for the script
chmod +x setup.sh

echo "Estrutura de projeto criada com sucesso!"

