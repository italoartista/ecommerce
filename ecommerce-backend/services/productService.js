const db = require('../config/database');

exports.createProduct = async (name, description, price, stock, category_id, image_url) => {
  const { rows } = await db.query(
    'INSERT INTO products (name, description, price, stock, category_id, image_url) VALUES (, , , , , ) RETURNING *',
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
    'UPDATE products SET name = , description = , price = , stock = , category_id = , image_url =  WHERE id =  RETURNING *',
    [name, description, price, stock, category_id, image_url, id]
  );
  return rows[0];
};

exports.deleteProduct = async (id) => {
  await db.query('DELETE FROM products WHERE id = ', [id]);
};
