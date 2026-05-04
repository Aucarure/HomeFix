const express = require('express');
require('dotenv').config();

const app = express();
app.use(express.json());
const usuariosRoutes = require('./routes/usuarios.routes');
app.use('/api/usuarios', usuariosRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'HomeFix API funcionando ✅' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});