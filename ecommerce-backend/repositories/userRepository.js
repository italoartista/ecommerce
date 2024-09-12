const db = require('../config/database');

exports.getUsers = async () => {
  const result = await db.query('SELECT * FROM users');
  return result.rows;
};

