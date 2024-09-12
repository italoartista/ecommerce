#!/bin/bash

# Nome do diretório do projeto
PROJECT_NAME="ecommerce-backend"

# Navegar para o diretório do projeto
cd $PROJECT_NAME

# Criar novos arquivos para CRUD de categorias e produtos
mkdir -p controllers categories models routes services

# Criar controlador para categorias
cat <<EOL > controllers/categoryController.js
const categoryService = require('../services/categoryService');

exports.createCategory = async (req, res) => {
  const { name } = req.body;
  try {
    const newCategory = await categoryService.createCategory(name);
    res.status(201).json(newCategory);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.getCategories = async (req, res) => {
  try {
    const categories = await categoryService.getCategories();
    res.status(200).json(categories);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.updateCategory = async (req, res) => {
  const { id } = req.params;
  const { name } = req.body;
  try {
    const updatedCategory = await categoryService.updateCategory(id, name);
    res.status(200).json(updatedCategory);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.deleteCategory = async (req, res) => {
  const { id } = req.params;
  try {
    await categoryService.deleteCategory(id);
    res.status(204).json({ message: 'Category deleted successfully' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
EOL

# Criar serviço de categorias
cat <<EOL > services/categoryService.js
const db = require('../config/database');

exports.createCategory = async (name) => {
  const { rows } = await db.query(
    'INSERT INTO categories (name) VALUES ($1) RETURNING *',
    [name]
  );
  return rows[0];
};

exports.getCategories = async () => {
  const { rows } = await db.query('SELECT * FROM categories');
  return rows;
};

exports.updateCategory = async (id, name) => {
  const { rows } = await db.query(
    'UPDATE categories SET name = $1 WHERE id = $2 RETURNING *',
    [name, id]
  );
  return rows[0];
};

exports.deleteCategory = async (id) => {
  await db.query('DELETE FROM categories WHERE id = $1', [id]);
};
EOL

# Criar rota para categorias
cat <<EOL > routes/categoryRoutes.js
const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/categoryController');

// Rotas de categorias
router.post('/', categoryController.createCategory);
router.get('/', categoryController.getCategories);
router.put('/:id', categoryController.updateCategory);
router.delete('/:id', categoryController.deleteCategory);

module.exports = router;
EOL

# Atualizar o arquivo principal app.js para incluir rotas de categorias
cat <<EOL >> app.js
const categoryRoutes = require('./routes/categoryRoutes');
app.use('/api/categories', categoryRoutes);
EOL

# Criar controlador para produtos
cat <<EOL > controllers/productController.js
const productService = require('../services/productService');

exports.createProduct = async (req, res) => {
  const { name, description, price, stock, category_id, image_url } = req.body;
  try {
    const newProduct = await productService.createProduct(name, description, price, stock, category_id, image_url);
    res.status(201).json(newProduct);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.getProducts = async (req, res) => {
  try {
    const products = await productService.getProducts();
    res.status(200).json(products);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.updateProduct = async (req, res) => {
  const { id } = req.params;
  const { name, description, price, stock, category_id, image_url } = req.body;
  try {
    const updatedProduct = await productService.updateProduct(id, name, description, price, stock, category_id, image_url);
    res.status(200).json(updatedProduct);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.deleteProduct = async (req, res) => {
  const { id } = req.params;
  try {
    await productService.deleteProduct(id);
    res.status(204).json({ message: 'Product deleted successfully' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
EOL

# Criar serviço de produtos
cat <<EOL > services/productService.js
const db = require('../config/database');

exports.createProduct = async (name, description, price, stock, category_id, image_url) => {
  const { rows } = await db.query(
    'INSERT INTO products (name, description, price, stock, category_id, image_url) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
    [name, description, price, stock, category_id, image_url]
  );
  return rows[0];
};

exports.getProducts = async () => {
  const { rows } = await db.query('SELECT * FROM products');
  return rows;
};

exports.updateProduct = async (id, name, description, price, stock, category_id, image_url) => {
  const { rows } = await db.query(
    'UPDATE products SET name = $1, description = $2, price = $3, stock = $4, category_id = $5, image_url = $6 WHERE id = $7 RETURNING *',
    [name, description, price, stock, category_id, image_url, id]
  );
  return rows[0];
};

exports.deleteProduct = async (id) => {
  await db.query('DELETE FROM products WHERE id = $1', [id]);
};
EOL

# Criar rota para produtos
cat <<EOL > routes/productRoutes.js
const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

// Rotas de produtos
router.post('/', productController.createProduct);
router.get('/', productController.getProducts);
router.put('/:id', productController.updateProduct);
router.delete('/:id', productController.deleteProduct);

module.exports = router;
EOL

# Atualizar o arquivo principal app.js para incluir rotas de produtos
cat <<EOL >> app.js
const productRoutes = require('./routes/productRoutes');
app.use('/api/products', productRoutes);
EOL

# Criar middleware de autenticação
cat <<EOL > middlewares/authMiddleware.js
const jwt = require('jsonwebtoken');
require('dotenv').config();

const authMiddleware = (req, res, next) => {
  const token = req.header('Authorization');
  
  if (!token) {
    return res.status(401).json({ message: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(400).json({ message: 'Invalid token.' });
  }
};

module.exports = authMiddleware;
EOL

# Atualizar pacotes de desenvolvimento e configurar Jest
npm install --save-dev jest supertest

# Criar arquivo de teste para usuários
mkdir -p __tests__
cat <<EOL > __tests__/user.test.js
const request = require('supertest');
const app = require('../app');

describe('User API', () => {
  it('should register a new user', async () => {
    const res = await request(app).post('/api/users/register').send({
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123'
    });
    expect(res.statusCode).toEqual(201);
    expect(res.body).toHaveProperty('email');
  });
});
EOL

# Finalizar a configuração
echo "Parte 2 do setup concluída! CRUD de categorias e produtos implementado, middlewares adicionados, e testes configurados."
