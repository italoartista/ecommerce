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
