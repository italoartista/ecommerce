const db = require('../config/database');

exports.createCategory = async (name) => {
  const { rows } = await db.query(
    'INSERT INTO categories (name) VALUES () RETURNING *',
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
    'UPDATE categories SET name =  WHERE id =  RETURNING *',
    [name, id]
  );
  return rows[0];
};

exports.deleteCategory = async (id) => {
  await db.query('DELETE FROM categories WHERE id = ', [id]);
};
