const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);
console.log(
  'SERVICE ROLE:',
  process.env.SUPABASE_SERVICE_KEY?.substring(0, 20)
);
module.exports = supabase;