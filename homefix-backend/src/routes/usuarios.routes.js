const express = require('express');
const router = express.Router();
const { getUsuarios, getPerfilTecnico, getUsuarioById, actualizarUsuario } = require('../controllers/usuarios.controller');

router.get('/', getUsuarios);
router.get('/:usuario_id/perfil', getPerfilTecnico);
router.get('/:id', getUsuarioById);           // ← agregar
router.patch('/:id', actualizarUsuario);       // ← agregar

module.exports = router;