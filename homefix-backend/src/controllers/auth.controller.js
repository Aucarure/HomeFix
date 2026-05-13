const supabase = require('../config/supabase')

const registrarCliente = async (req, res) => {
  const { nombre_completo, correo, telefono, password } = req.body

  if (!nombre_completo || !correo || !telefono || !password) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios' })
  }

  const { data, error } = await supabase.auth.signUp({
    email: correo,
    password,
    options: {
      data: { nombre_completo, telefono, rol: 'cliente' }
    }
  })

  if (error) return res.status(400).json({ error: error.message })

  return res.status(201).json({
    mensaje: 'Cliente registrado. Revisa tu correo para verificar tu cuenta.',
    usuario_id: data.user?.id
  })
}

const registrarTecnico = async (req, res) => {
  const { nombre_completo, correo, telefono, password } = req.body
  const archivos = req.files

  if (!nombre_completo || !correo || !telefono || !password) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios' })
  }

  if (!archivos || archivos.length === 0) {
    return res.status(400).json({ error: 'Debes subir al menos un certificado' })
  }

  const { data: authData, error: authError } = await supabase.auth.signUp({
    email: correo,
    password,
    options: {
      data: { nombre_completo, telefono, rol: 'tecnico' }
    }
  })

  if (authError) return res.status(400).json({ error: authError.message })

  const usuarioId = authData.user?.id

  const { data: perfilData, error: perfilError } = await supabase
    .from('perfil_tecnico')
    .insert({ usuario_id: usuarioId })
    .select()
    .single()

  if (perfilError) return res.status(400).json({ error: perfilError.message })

  const perfilTecnicoId = perfilData.id

  const urlsCertificados = []

  for (const archivo of archivos) {
    const nombreLimpio = archivo.originalname
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '') // quita tildes
      .replace(/[^a-zA-Z0-9._-]/g, '_') // reemplaza espacios y especiales por _

    const nombreArchivo = `${usuarioId}/${Date.now()}_${nombreLimpio}`
    const extension = archivo.originalname.split('.').pop().toLowerCase()

    const { error: storageError } = await supabase.storage
      .from('certificados')
      .upload(nombreArchivo, archivo.buffer, {
        contentType: archivo.mimetype,
        upsert: false
      })

    if (storageError) {
      return res.status(400).json({ error: `Error subiendo archivo: ${storageError.message}` })
    }

    const { data: urlData } = supabase.storage
      .from('certificados')
      .getPublicUrl(nombreArchivo)

    await supabase.from('documentos_tecnico').insert({
      perfil_tecnico_id: perfilTecnicoId,
      tipo: extension === 'pdf' ? 'pdf' : 'imagen',
      url_archivo: urlData.publicUrl
    })

    urlsCertificados.push(urlData.publicUrl)
  }

  await supabase.from('verificaciones_tecnico').insert({
    perfil_tecnico_id: perfilTecnicoId,
    estado: 'pendiente'
  })

  return res.status(201).json({
    mensaje: 'Técnico registrado. Revisa tu correo y espera la verificación del equipo HomeFix.',
    usuario_id: usuarioId,
    certificados_subidos: urlsCertificados.length
  })
}

const login = async (req, res) => {
  const { correo, password } = req.body

  if (!correo || !password) {
    return res.status(400).json({ error: 'Correo y contraseña son obligatorios' })
  }

  const { data, error } = await supabase.auth.signInWithPassword({
    email: correo,
    password
  })

  if (error) return res.status(401).json({ error: 'Credenciales incorrectas' })

  const { data: usuarioData, error: usuarioError } = await supabase
    .from('usuarios')
    .select('id, nombre_completo, rol, esta_activo, foto_perfil_url')
    .eq('id', data.user.id)
    .single()

  if (usuarioError) return res.status(400).json({ error: usuarioError.message })

  if (!usuarioData.esta_activo) {
    return res.status(403).json({ error: 'Tu cuenta está desactivada' })
  }

  return res.status(200).json({
    mensaje: 'Login exitoso',
    token: data.session.access_token,
    usuario: {
      id: usuarioData.id,
      nombre_completo: usuarioData.nombre_completo,
      rol: usuarioData.rol,
      foto_perfil_url: usuarioData.foto_perfil_url
    }
  })
}

module.exports = { registrarCliente, registrarTecnico, login }