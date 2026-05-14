const supabase = require('../config/supabase');

const getUsuarios = async (req, res) => {
  const { data, error } = await supabase.from('usuarios').select('*');
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};

const getPerfilTecnico = async (req, res) => {
  const { usuario_id } = req.params;

  const { data: usuario, error: errUser } = await supabase
    .from('usuarios')
    .select('id, nombre_completo, foto_perfil_url, telefono, telefono_verificado')
    .eq('id', usuario_id)
    .single();

  if (errUser) return res.status(500).json({ error: errUser.message });

  const { data: perfil } = await supabase
    .from('perfil_tecnico')
    .select('id, edad, activo')
    .eq('usuario_id', usuario_id)
    .single();

  const { data: documentos } = perfil
    ? await supabase
        .from('documentos_tecnico')
        .select('tipo, url_archivo')
        .eq('perfil_tecnico_id', perfil.id)
    : { data: [] };

  const { data: calificaciones } = await supabase
  .from('calificaciones')
  .select('estrellas, comentario, creado_en')
  .eq('usuario_id', usuario_id)
  .order('creado_en', { ascending: false })
  .limit(10);
  
  const lista = calificaciones ?? [];
  const promedio = lista.length
    ? (lista.reduce((s, c) => s + c.estrellas, 0) / lista.length).toFixed(1)
    : null;

  res.json({
    ...usuario,
    edad: perfil?.edad ?? null,
    activo: perfil?.activo ?? false,
    documentos: documentos ?? [],
    calificaciones: lista,
    promedio_estrellas: promedio,
    total_calificaciones: lista.length,
  });
};
const getUsuarioById = async (req, res) => {
  const { id } = req.params;
  const { data, error } = await supabase
    .from('usuarios')
    .select('id, nombre_completo, telefono, foto_perfil_url, rol')
    .eq('id', id)
    .single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};

const actualizarUsuario = async (req, res) => {
  const { id } = req.params;
  const { nombre_completo, telefono } = req.body;

  const { data, error } = await supabase
    .from('usuarios')
    .update({ nombre_completo, telefono, actualizado_en: new Date() })
    .eq('id', id)
    .select()
    .single();

  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};
module.exports = { getUsuarios, getPerfilTecnico, getUsuarioById, actualizarUsuario };
