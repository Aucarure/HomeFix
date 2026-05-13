const express = require('express');
const router = express.Router();
const { getUsuarios, getPerfilTecnico } = require('../controllers/usuarios.controller');

router.get('/', getUsuarios);
router.get('/:usuario_id/perfil', getPerfilTecnico);

module.exports = router;