const express = require('express');
const router = express.Router();
const { analizar, confirmar, getSolicitudesByUsuario } = require('../controllers/solicitudes.controller');

// PASO 1 — analiza texto+imagen, devuelve preguntas (no guarda en BD)
router.post('/analizar', analizar);

// PASO 2 — recibe respuestas, guarda en BD, devuelve precio estimado final
router.post('/confirmar', confirmar);

// historial de solicitudes de un usuario
router.get('/:usuario_id', getSolicitudesByUsuario);

module.exports = router;