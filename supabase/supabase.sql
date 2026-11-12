-- Abundance database schema.
-- Run this once in Supabase: SQL Editor → New query → paste → Run.

-- One row per person: monthly budgets and their categories (JSON).
create table if not exists public.settings (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null default '{"budgets":{}}'::jsonb,
  updated_at timestamptz not null default now()
);

-- One row per expense.
create table if not exists public.expenses (
  id         text primary key,
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  amount     numeric(12,2) not null check (amount > 0),
  note       text not null check (char_length(note) between 1 and 200),
  date       date not null,
  month      text not null check (month ~ '^\d{4}-\d{2}$'),
  category   text not null default 'uncat',
  created_at bigint not null default (extract(epoch from now()) * 1000)::bigint
);
create index if not exists expenses_user_month_idx on public.expenses (user_id, month);

-- Row-level security: each person can only see and change their own rows.
alter table public.settings enable row level security;
alter table public.expenses enable row level security;

drop policy if exists "Own settings" on public.settings;
create policy "Own settings" on public.settings
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "Own expenses" on public.expenses;
create policy "Own expenses" on public.expenses
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Live sync between your phone and laptop.
alter table public.expenses replica identity full;
alter table public.settings replica identity full;
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'expenses') then
    alter publication supabase_realtime add table public.expenses;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'settings') then
    alter publication supabase_realtime add table public.settings;
  end if;
end $$;
