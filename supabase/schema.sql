-- 人员配合度反馈（免登录可读写）
create table if not exists public.coop_feedback (
  id uuid primary key default gen_random_uuid(),
  submitter_name text not null,
  target_name text not null,
  resp_speed text not null check (resp_speed in ('好', '中', '差')),
  communication text not null check (communication in ('好', '中', '差')),
  closure text not null check (closure in ('好', '中', '差')),
  initiative text not null check (initiative in ('好', '中', '差')),
  punctuality text not null check (punctuality in ('好', '中', '差')),
  suggestion text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists idx_coop_feedback_created on public.coop_feedback (created_at desc);
create index if not exists idx_coop_feedback_target on public.coop_feedback (target_name);

alter table public.coop_feedback enable row level security;

drop policy if exists "public read coop_feedback" on public.coop_feedback;
drop policy if exists "public insert coop_feedback" on public.coop_feedback;

create policy "public read coop_feedback" on public.coop_feedback for select using (true);
create policy "public insert coop_feedback" on public.coop_feedback for insert with check (true);

alter publication supabase_realtime add table public.coop_feedback;
