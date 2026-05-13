const supabase = require('../config/supabase');

const getOfertasBySolicitud = async (req, res) => {
  const { solicitud_id } = req.params;

  const { data, error } = await supabase
    .from('ofertas')
    .select(`
      id,
      precio_ofertado,
      precio_negociado,
      mensaje,
      estado,
      ronda,
      creado_en,
      usuario_id,
      usuarios (
        id,
        nombre_completo,
        foto_perfil_url,
        telefono
      )
    `)
    .eq('solicitud_id', solicitud_id)
    .in('estado', ['pendiente', 'negociando']);

  if (error) return res.status(500).json({ error: error.message });

  const usuarioIds = data.map((o) => o.usuario_id);

  const { data: ubicaciones, error: errorUbic } = await supabase
    .from('ubicacion_tecnico')
    .select('usuario_id, latitud, longitud, actualizado_en')
    .in('usuario_id', usuarioIds);

  if (errorUbic) return res.status(500).json({ error: errorUbic.message });

  const resultado = data.map((oferta) => ({
    ...oferta,
    ubicacion: ubicaciones.find((u) => u.usuario_id === oferta.usuario_id) || null,
  }));

  res.json(resultado);
};

const negociarOferta = async (req, res) => {
  const { id } = req.params;
  const { precio_negociado } = req.body;

  if (!precio_negociado || precio_negociado <= 0) {
    return res.status(400).json({ error: 'Precio inválido' });
  }

  const { data, error } = await supabase
    .from('ofertas')
    .update({ precio_negociado, estado: 'negociando' })
    .eq('id', id)
    .select()
    .single();

  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};

const getEstadoOferta = async (req, res) => {
  const { id } = req.params;

  const { data, error } = await supabase
    .from('ofertas')
    .select('id, estado, precio_negociado')
    .eq('id', id)
    .single();

  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};

module.exports = { getOfertasBySolicitud, negociarOferta, getEstadoOferta };