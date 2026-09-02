-- 个人红榜在线填写（免登录可读写）
create table if not exists public.redlist_entries (
  id uuid primary key default gen_random_uuid(),
  domain text not null,
  department text not null,
  person_name text not null,
  project_name text not null,
  behavior text not null,
  reason text not null,
  submitter_name text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists idx_redlist_created on public.redlist_entries (created_at desc);
create index if not exists idx_redlist_person on public.redlist_entries (person_name);

alter table public.redlist_entries enable row level security;

drop policy if exists "public read redlist" on public.redlist_entries;
drop policy if exists "public insert redlist" on public.redlist_entries;

create policy "public read redlist" on public.redlist_entries for select using (true);
create policy "public insert redlist" on public.redlist_entries for insert with check (true);

alter publication supabase_realtime add table public.redlist_entries;
