-- 研发不配合污点反馈（免登录可读写）
drop table if exists public.coop_feedback cascade;

create table public.coop_feedback (
  id uuid primary key default gen_random_uuid(),
  submitter_name text not null,
  target_name text not null,
  issue_types text[] not null default '{}',
  stain_level text not null check (stain_level in ('轻微', '一般', '严重')),
  stain_points int not null check (stain_points in (1, 2, 3)),
  fact_detail text not null,
  suggestion text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists idx_coop_feedback_created on public.coop_feedback (created_at desc);
create index if not exists idx_coop_feedback_target on public.coop_feedback (target_name);
create index if not exists idx_coop_feedback_points on public.coop_feedback (stain_points desc);

alter table public.coop_feedback enable row level security;

drop policy if exists "public read coop_feedback" on public.coop_feedback;
drop policy if exists "public insert coop_feedback" on public.coop_feedback;

create policy "public read coop_feedback" on public.coop_feedback for select using (true);
create policy "public insert coop_feedback" on public.coop_feedback for insert with check (true);

alter publication supabase_realtime add table public.coop_feedback;
