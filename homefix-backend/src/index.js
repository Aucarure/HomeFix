const express = require('express');
require('dotenv').config();

const app = express();
app.use(express.json({ limit: '20mb' }));

app.use(express.json());

const usuariosRoutes = require('./routes/usuarios.routes');
const solicitudesRoutes = require('./routes/solicitudes.routes');

app.use('/api/usuarios', usuariosRoutes);
app.use('/api/solicitudes', solicitudesRoutes);


const ofertasRoutes = require('./routes/ofertas.routes');
app.use('/api/ofertas', ofertasRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'HomeFix API funcionando ✅' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});