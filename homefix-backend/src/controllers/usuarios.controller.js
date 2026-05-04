const supabase = require('../config/supabase');

const getUsuarios = async (req, res) => {
  const { data, error } = await supabase
    .from('usuarios')
    .select('*');

  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
};

module.exports = { getUsuarios };