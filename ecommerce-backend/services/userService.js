// userService.js
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const userRepository = require('../repostitory/userRepository');

// Criar novo usuário
exports.createUser = async (name, email, password) => {
  const hashedPassword = await bcrypt.hash(password, 10);
  return await userRepository.createUser(name, email, hashedPassword);
};

// Login de usuário
exports.login = async (email, password) => {
  const user = await userRepository.findUserByEmail(email);
  
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