-- DeutschKompass schema for the existing NEXYRON Supabase project
-- Safe to run more than once. Does not alter existing game or chat tables.

create table if not exists public.deutsch_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  current_level text not null default 'A1' check (current_level in ('A1','A2','B1','B2')),
  target_level text not null default 'A2' check (target_level in ('A1','A2','B1','B2')),
  speaking_level text not null default 'A1' check (speaking_level in ('A1','A2','B1','B2')),
  daily_minutes integer not null default 20 check (daily_minutes between 5 and 180),
  goals text[] not null default '{}',
  placement_answers jsonb not null default '{}'::jsonb,
  onboarding_done boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.deutsch_plans (
  user_id uuid primary key references auth.users(id) on delete cascade,
  plan jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create table if not exists public.deutsch_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  level text not null check (level in ('A1','A2','B1','B2')),
  test_type text not null check (test_type in ('writing','reading','listening','grammar','vocabulary','mixed')),
  title text not null,
  score numeric(5,2) not null default 0,
  max_score numeric(5,2) not null default 100,
  answers jsonb not null default '{}'::jsonb,
  feedback jsonb not null default '{}'::jsonb,
  duration_seconds integer not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists deutsch_attempts_user_created_idx on public.deutsch_attempts(user_id, created_at desc);
create table if not exists public.deutsch_vocab (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  word text not null,
  translation text not null default '',
  example text not null default '',
  level text not null default 'A1' check (level in ('A1','A2','B1','B2')),
  status text not null default 'new' check (status in ('new','learning','known')),
  next_review_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  unique(user_id, word)
);

alter table public.deutsch_profiles enable row level security;
alter table public.deutsch_plans enable row level security;
alter table public.deutsch_attempts enable row level security;
alter table public.deutsch_vocab enable row level security;

drop policy if exists deutsch_profiles_select_own on public.deutsch_profiles;
create policy deutsch_profiles_select_own on public.deutsch_profiles for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists deutsch_profiles_insert_own on public.deutsch_profiles;
create policy deutsch_profiles_insert_own on public.deutsch_profiles for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists deutsch_profiles_update_own on public.deutsch_profiles;
create policy deutsch_profiles_update_own on public.deutsch_profiles for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists deutsch_plans_all_own on public.deutsch_plans;
create policy deutsch_plans_all_own on public.deutsch_plans for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists deutsch_attempts_select_own on public.deutsch_attempts;
create policy deutsch_attempts_select_own on public.deutsch_attempts for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists deutsch_attempts_insert_own on public.deutsch_attempts;
create policy deutsch_attempts_insert_own on public.deutsch_attempts for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists deutsch_vocab_all_own on public.deutsch_vocab;
create policy deutsch_vocab_all_own on public.deutsch_vocab for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.deutsch_profiles to authenticated;
grant select, insert, update, delete on public.deutsch_plans to authenticated;
grant select, insert on public.deutsch_attempts to authenticated;
grant select, insert, update, delete on public.deutsch_vocab to authenticated;
