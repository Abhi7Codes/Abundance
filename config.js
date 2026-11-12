// Abundance — Supabase connection settings.
// Find both values in Supabase: Project Settings → API.
// The anon key is safe to publish: row-level security in supabase/schema.sql
// makes sure each signed-in person can only read and write their own rows.
window.ABUNDANCE_CONFIG = {
  supabaseUrl: "https://ujxmcxemfpmjxgriybkg.supabase.co",
  supabaseAnonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVqeG1jeGVtZnBtanhncml5YmtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQ0NTg3MTgsImV4cCI6MjExMDAzNDcxOH0.Xmeu7jeyz24S1vz_VKoYXn6KwaqvWu64q-bpdp2NRf4"
};
