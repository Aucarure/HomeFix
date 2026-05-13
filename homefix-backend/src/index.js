const express = require('express');
require('dotenv').config();

const app = express();
app.use(express.json({ limit: '20mb' }));

const usuariosRoutes = require('./routes/usuarios.routes');
const solicitudesRoutes = require('./routes/solicitudes.routes');

app.use('/api/usuarios', usuariosRoutes);
app.use('/api/solicitudes', solicitudesRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'HomeFix API funcionando ✅' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});