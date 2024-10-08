const express = require('express');
const app = express();
require('dotenv').config();

app.use(express.json());

// Rotas
const userRoutes = require('./routes/userRoutes');
app.use('/api/users', userRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;
const categoryRoutes = require('./routes/categoryRoutes');
app.use('/api/categories', categoryRoutes);
const productRoutes = require('./routes/productRoutes');
app.use('/api/products', productRoutes);
