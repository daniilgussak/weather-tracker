-- Трекер погоды: таблица и правила доступа для Supabase.
-- Выполните целиком в Supabase: SQL Editor -> New query -> Run.
-- Скрипт можно запускать повторно.

create table if not exists public.weather_entries (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  date        date not null,
  part        text not null check (part in ('morning', 'day', 'evening')),  -- утро, день, вечер
  t           numeric not null check (t between -90 and 70),                -- температура, °C
  f           numeric check (f between -100 and 80),                        -- по ощущениям, °C
  uv          numeric check (uv >= 0 and uv <= 20),                         -- УФ-индекс
  p           numeric check (p >= 0),                                       -- осадки, мм
  h           numeric check (h >= 0 and h <= 100),                          -- влажность, %
  pr          numeric check (pr between 300 and 1200),                      -- давление, гПа
  v           numeric check (v >= 0),                                       -- видимость, км
  w           numeric check (w >= 0),                                       -- ветер, км/ч
  g           numeric check (g >= 0),                                       -- порывы, км/ч
  wd          numeric check (wd >= 0 and wd <= 360),                        -- направление, градусы
  wl          text check (wl in ('С', 'СВ', 'В', 'ЮВ', 'Ю', 'ЮЗ', 'З', 'СЗ')), -- направление, буквы
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (user_id, date, part),
  check (g is null or w is null or g >= w)
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists weather_entries_updated on public.weather_entries;
create trigger weather_entries_updated
  before update on public.weather_entries
  for each row execute function public.set_updated_at();

-- Каждый пользователь видит и меняет только свои записи.
alter table public.weather_entries enable row level security;

drop policy if exists "weather select own" on public.weather_entries;
drop policy if exists "weather insert own" on public.weather_entries;
drop policy if exists "weather update own" on public.weather_entries;
drop policy if exists "weather delete own" on public.weather_entries;

create policy "weather select own" on public.weather_entries
  for select to authenticated using (auth.uid() = user_id);

create policy "weather insert own" on public.weather_entries
  for insert to authenticated with check (auth.uid() = user_id);

create policy "weather update own" on public.weather_entries
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "weather delete own" on public.weather_entries
  for delete to authenticated using (auth.uid() = user_id);
