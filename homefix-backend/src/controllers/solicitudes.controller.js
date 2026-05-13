const supabase = require('../config/supabase');
const OpenAI = require('openai');
const https = require('https');
const http = require('http');

const openai = new OpenAI({
  apiKey: process.env.GROQ_API_KEY,
  baseURL: 'https://api.groq.com/openai/v1',
});

// ─── Helpers ────────────────────────────────────────────────────────────────

const urlABase64 = (url) => {
  return new Promise((resolve, reject) => {
    const client = url.startsWith('https') ? https : http;
    client.get(url, (res) => {
      const chunks = [];
      res.on('data', (chunk) => chunks.push(chunk));
      res.on('end', () => {
        const buffer = Buffer.concat(chunks);
        const base64 = buffer.toString('base64');
        const mimeType = res.headers['content-type'] || 'image/jpeg';
        resolve({ base64, mimeType });
      });
      res.on('error', reject);
    }).on('error', reject);
  });
};

const mejorarTexto = async (textoOriginal) => {
  const completion = await openai.chat.completions.create({
    model: 'meta-llama/llama-4-scout-17b-16e-instruct',
    messages: [
      {
        role: 'system',
        content: `Eres un asistente que ayuda a usuarios a describir problemas técnicos del hogar de forma clara y precisa.
Tu tarea es reescribir el mensaje del usuario para que sea más claro, específico y útil para un técnico.
Mantén el mismo problema pero mejora la redacción. Responde SOLO con el texto mejorado, sin explicaciones ni comentarios.`,
      },
      { role: 'user', content: textoOriginal },
    ],
  });
  return completion.choices[0].message.content.trim();
};

// Acepta base64 como string (1 imagen) o array (varias imágenes)
const analizarYGenerarPreguntas = async (texto, base64, mimeType) => {
  const contentUser = [];

  if (base64) {
    const imagenes = Array.isArray(base64) ? base64 : [base64];
    for (const img of imagenes) {
      contentUser.push({
        type: 'image_url',
        image_url: { url: `data:${mimeType};base64,${img}` },
      });
    }
  }

  contentUser.push({
    type: 'text',
    text: texto
      ? `El usuario describe el problema así: "${texto}". Analiza todas las imágenes y el texto. IMPORTANTE: en "problema_detectado" describe específicamente lo que VES en las imágenes (materiales, colores, ubicación exacta del problema).`
      : 'Analiza el problema visible en todas las imágenes. IMPORTANTE: en "problema_detectado" describe específicamente lo que VES (materiales, colores, ubicación exacta del problema).',
  });

  const completion = await openai.chat.completions.create({
    model: 'meta-llama/llama-4-scout-17b-16e-instruct',
    messages: [
      {
        role: 'system',
        content: `Eres un experto en servicios técnicos del hogar en Lima, Perú.
Analiza el problema descrito y/o visible en las imágenes y genera exactamente 5 preguntas cortas y precisas para entender mejor el problema antes de dar un precio estimado.
Las preguntas deben ayudar a determinar la gravedad, el alcance y los materiales necesarios.
Responde SOLO con un JSON válido con esta estructura:
{
  "problema_detectado": "descripción específica de lo visible en las imágenes",
  "categoria": "electricidad | gasfitería | carpintería | pintura | otro",
  "preguntas": [
    { "id": 1, "pregunta": "¿...?" },
    { "id": 2, "pregunta": "¿...?" },
    { "id": 3, "pregunta": "¿...?" },
    { "id": 4, "pregunta": "¿...?" },
    { "id": 5, "pregunta": "¿...?" }
  ]
}`,
      },
      { role: 'user', content: contentUser },
    ],
  });

  const raw = completion.choices[0].message.content.trim();
  const clean = raw
    .replace(/^```json\s*/i, '')
    .replace(/^```\s*/i, '')
    .replace(/```$/i, '')
    .trim();
  return JSON.parse(clean);
};

const estimarPrecioConRespuestas = async (problema, categoria, texto, respuestas) => {
  const respuestasTexto = respuestas
    .map((r) => `Pregunta: ${r.pregunta}\nRespuesta: ${r.respuesta}`)
    .join('\n\n');

  const completion = await openai.chat.completions.create({
    model: 'meta-llama/llama-4-scout-17b-16e-instruct',
    messages: [
      {
        role: 'system',
        content: `Eres un experto en servicios técnicos del hogar en Lima, Perú.
Con base en el problema detectado y las respuestas del usuario, da un precio estimado realista en soles peruanos.
Responde SOLO con un JSON válido con esta estructura:
{
  "precio_minimo": 80,
  "precio_maximo": 150,
  "moneda": "PEN",
  "nivel_urgencia": "bajo | medio | alto",
  "justificacion": "breve explicación de por qué ese rango de precio",
  "observaciones": "nota útil para el técnico"
}`,
      },
      {
        role: 'user',
        content: `Problema detectado: ${problema}
Categoría: ${categoria}
Descripción del usuario: ${texto || 'No proporcionada'}

Respuestas del usuario a las preguntas de diagnóstico:
${respuestasTexto}`,
      },
    ],
  });

  const raw = completion.choices[0].message.content.trim();
  const clean = raw
    .replace(/^```json\s*/i, '')
    .replace(/^```\s*/i, '')
    .replace(/```$/i, '')
    .trim();
  return JSON.parse(clean);
};

// ─── Controllers ─────────────────────────────────────────────────────────────

// ENDPOINT 1: POST /api/solicitudes/analizar
const analizar = async (req, res) => {
  const { texto, imagen_url, imagen_base64, imagenes_base64 } = req.body;

  const tieneImagen =
    imagen_url ||
    imagen_base64 ||
    (imagenes_base64 && imagenes_base64.length > 0);

  if (!tieneImagen) {
    return res.status(400).json({ error: 'La imagen es obligatoria.' });
  }

  try {
    let textoMejorado = texto || null;
    let base64 = null;
    let mimeType = 'image/jpeg';

    if (texto) {
      textoMejorado = await mejorarTexto(texto);
    }

    if (imagen_url) {
      // URL pública → descarga y convierte
      const resultado = await urlABase64(imagen_url);
      base64 = resultado.base64;
      mimeType = resultado.mimeType;
    } else if (imagenes_base64 && imagenes_base64.length > 0) {
      // Múltiples imágenes desde Flutter
      base64 = imagenes_base64;
      mimeType = 'image/jpeg';
    } else if (imagen_base64) {
      // Una sola imagen desde Flutter
      base64 = imagen_base64;
      mimeType = 'image/jpeg';
    }

    const analisis = await analizarYGenerarPreguntas(textoMejorado, base64, mimeType);

    res.status(200).json({
      texto_mejorado: textoMejorado,
      imagen_url: imagen_url || null,
      problema_detectado: analisis.problema_detectado,
      categoria: analisis.categoria,
      preguntas: analisis.preguntas,
    });
  } catch (err) {
    console.error('Error analizar:', err);
    res.status(500).json({ error: 'Error al analizar el problema con IA.' });
  }
};

// ENDPOINT 2: POST /api/solicitudes/confirmar
const confirmar = async (req, res) => {
  const {
    usuario_id,
    categoria_id,
    direccion_id,
    texto_mejorado,
    imagen_url,
    problema_detectado,
    categoria,
    preguntas_respuestas,
  } = req.body;

  if (!usuario_id || !preguntas_respuestas) {
    return res.status(400).json({ error: 'Faltan datos para confirmar la solicitud.' });
  }

  try {
    // 1. Estimar precio con las respuestas
    const estimacion = await estimarPrecioConRespuestas(
      problema_detectado,
      categoria,
      texto_mejorado,
      preguntas_respuestas
    );

    // 2. Guardar solicitud
    const { data: solicitud, error: errorSolicitud } = await supabase
      .from('solicitudes')
      .insert([
        {
          usuario_id,
          categoria_id: categoria_id || null,
          direccion_id: direccion_id || null,
          descripcion: texto_mejorado || null,
          descripcion_mejorada: texto_mejorado || null,
          estado: 'pendiente',
        },
      ])
      .select()
      .single();

    if (errorSolicitud) return res.status(500).json({ error: errorSolicitud.message });

    // 3. Guardar imagen si existe
    if (imagen_url) {
      const { error: errorImagen } = await supabase
        .from('solicitud_imagenes')
        .insert([{ solicitud_id: solicitud.id, url_imagen: imagen_url }]);

      if (errorImagen) return res.status(500).json({ error: errorImagen.message });
    }

    // 4. Guardar preguntas y respuestas
    const preguntasRows = preguntas_respuestas.map((pr, index) => ({
      solicitud_id: solicitud.id,
      pregunta: pr.pregunta,
      respuesta: pr.respuesta,
      orden: index + 1,
    }));

    const { error: errorPreguntas } = await supabase
      .from('solicitud_preguntas')
      .insert(preguntasRows);

    if (errorPreguntas) return res.status(500).json({ error: errorPreguntas.message });

    // 5. Respuesta final — precio estimado solo al frontend, no se guarda en BD
    res.status(201).json({
      solicitud,
      ia: {
        problema_detectado,
        categoria,
        precio_minimo: estimacion.precio_minimo,
        precio_maximo: estimacion.precio_maximo,
        moneda: estimacion.moneda,
        nivel_urgencia: estimacion.nivel_urgencia,
        justificacion: estimacion.justificacion,
        observaciones: estimacion.observaciones,
      },
    });
  } catch (err) {
    console.error('Error confirmar:', err);
    res.status(500).json({ error: 'Error al confirmar la solicitud con IA.' });
  }
};

// GET /api/solicitudes/:usuario_id
const getSolicitudesByUsuario = async (req, res) => {
  const { usuario_id } = req.params;

  const { data, error } = await supabase
    .from('solicitudes')
    .select('*, solicitud_imagenes(url_imagen), solicitud_preguntas(orden, pregunta, respuesta)')
    .eq('usuario_id', usuario_id)
    .order('creado_en', { ascending: false });

  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};

module.exports = { analizar, confirmar, getSolicitudesByUsuario };