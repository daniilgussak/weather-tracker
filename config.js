// Настройки подключения к Supabase.
// Эти два значения можно брать в Supabase: Project Settings -> API.
// Публичный ключ (anon или publishable) безопасно хранить в репозитории:
// данные защищены правилами доступа (RLS) из файла schema.sql.
// НИКОГДА не вставляйте сюда ключ service_role / secret.
window.APP_CONFIG = {
  SUPABASE_URL: "https://csijcsnwtquzdknhmtnt.supabase.co",          // например: https://abcdxyz.supabase.co
  SUPABASE_ANON_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNzaWpjc253dHF1emRrbmhtdG50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE4MTk3MTYsImV4cCI6MjEwNzM5NTcxNn0.nI61gfhtXovl4hzke0-ukR0uUh_3O1i0fY_OTnJEa1U"   // anon public / publishable key
};
