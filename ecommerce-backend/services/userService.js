const db = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Criar novo usuário
exports.createUser = async (name, email, password) => {
  const { rows } = await db.query(
    'INSERT INTO users (name, email, password) VALUES (, , ) RETURNING *',
    [name, email, password]
  );
  return rows[0];
};

// Login de usuário
exports.login = async (email, password) => {
  const { rows } = await db.query('SELECT * FROM users WHERE email = ', [email]);
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
