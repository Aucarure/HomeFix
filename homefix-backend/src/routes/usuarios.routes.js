const express = require('express');
const router = express.Router();
const { getUsuarios } = require('../controllers/usuarios.controller');

router.get('/', getUsuarios);

module.exports = router;