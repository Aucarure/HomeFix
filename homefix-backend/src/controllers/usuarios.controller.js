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

module.exports = { getUsuarios, getPerfilTecnico };