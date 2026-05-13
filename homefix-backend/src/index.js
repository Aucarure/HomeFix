const express = require('express')
require('dotenv').config()

const app = express()
app.use(express.json())

// Rutas existentes
const usuariosRoutes = require('./routes/usuarios.routes')
app.use('/api/usuarios', usuariosRoutes)

// Rutas nuevas de auth
app.use('/api/auth', require('./routes/auth.routes'))

app.get('/', (req, res) => {
  res.json({ message: 'HomeFix API funcionando ✅' })
})

const PORT = process.env.PORT || 3000
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`)
})