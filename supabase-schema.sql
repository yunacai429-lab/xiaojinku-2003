-- 在 Supabase 控制台的 SQL Editor 中完整执行一次
create table if not exists public.ledger_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.ledger_data enable row level security;

drop policy if exists "Users can read own ledger" on public.ledger_data;
create policy "Users can read own ledger"
on public.ledger_data for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can insert own ledger" on public.ledger_data;
create policy "Users can insert own ledger"
on public.ledger_data for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update own ledger" on public.ledger_data;
create policy "Users can update own ledger"
on public.ledger_data for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

revoke all on table public.ledger_data from anon;
grant select, insert, update on table public.ledger_data to authenticated;
