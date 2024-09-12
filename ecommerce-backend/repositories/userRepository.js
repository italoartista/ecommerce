const db = require('../config/database');

exports.getUsers = async () => {
  const result = await db.query('SELECT * FROM users');
  return result.rows;
};


exports.createUser = async (name, email, password) => {
  const { rows } = await db.query(
    'INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING *',
    [name, email, password]
  );
  return rows[0];
};

exports.findUserByEmail = async (email) => {
  const { rows } = await db.query('SELECT * FROM users WHERE email = $1', [email]);
  return rows[0];
};