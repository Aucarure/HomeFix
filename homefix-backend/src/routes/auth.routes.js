const express = require('express')
const router = express.Router()
const multer = require('multer')
const { registrarCliente, registrarTecnico, login } = require('../controllers/auth.controller')

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    const tiposPermitidos = ['application/pdf', 'image/png', 'image/jpeg']
    if (tiposPermitidos.includes(file.mimetype)) {
      cb(null, true)
    } else {
      cb(new Error('Solo se permiten archivos PDF, PNG o JPG'))
    }
  }
})

router.post('/registro/cliente', registrarCliente)
router.post('/registro/tecnico', upload.array('certificados', 5), registrarTecnico)
router.post('/login', login)

module.exports = router