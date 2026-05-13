const express = require('express');
const router = express.Router();
const {
  getOfertasBySolicitud,
  negociarOferta,
  getEstadoOferta,
} = require('../controllers/ofertas.controller');

router.get('/:solicitud_id', getOfertasBySolicitud);
router.post('/:id/negociar', negociarOferta);
router.get('/:id/estado', getEstadoOferta);

module.exports = router;