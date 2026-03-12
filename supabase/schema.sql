create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create table if not exists public.study_tracks (
  id text primary key,
  name text not null,
  description text not null,
  icon_key text not null,
  color_hex text not null,
  roadmap_summary text not null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.study_skills (
  id text primary key,
  track_id text not null references public.study_tracks(id) on delete cascade,
  name text not null,
  description text not null,
  target_level text not null check (target_level in ('beginner', 'junior', 'mid_level', 'senior')),
  sort_order integer not null default 1,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.study_modules (
  id text primary key,
  track_id text not null references public.study_tracks(id) on delete cascade,
  title text not null,
  summary text not null,
  estimated_hours integer not null default 0,
  sort_order integer not null default 1,
  is_core boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  email text,
  desired_area text not null default 'Tecnologia',
  current_level text not null default 'beginner'
    check (current_level in ('beginner', 'junior', 'mid_level', 'senior')),
  onboarding_completed boolean not null default false,
  selected_track_id text references public.study_tracks(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.user_goals (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  primary_goal text not null,
  desired_area text not null,
  focus_type text not null check (
    focus_type in ('job', 'promotion', 'freelance', 'solid_foundation', 'career_transition')
  ),
  hours_per_day integer not null default 2,
  days_per_week integer not null default 5,
  deadline timestamptz not null,
  current_level text not null check (
    current_level in ('beginner', 'junior', 'mid_level', 'senior')
  ),
  generated_plan text not null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.user_skill_progress (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  skill_id text not null references public.study_skills(id) on delete cascade,
  progress_percent numeric(5,2) not null default 0 check (progress_percent >= 0 and progress_percent <= 100),
  last_studied_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (user_id, skill_id)
);

create table if not exists public.study_sessions (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  track_id text references public.study_tracks(id) on delete set null,
  skill_id text references public.study_skills(id) on delete set null,
  module_id text references public.study_modules(id) on delete set null,
  type text not null check (type in ('theory', 'practice', 'review', 'project', 'exercises')),
  start_time timestamptz not null,
  end_time timestamptz not null,
  duration_minutes integer not null default 0,
  notes text not null default '',
  productivity_score integer not null default 3 check (productivity_score between 1 and 5),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.tasks (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  track_id text references public.study_tracks(id) on delete set null,
  module_id text references public.study_modules(id) on delete set null,
  title text not null,
  description text not null default '',
  priority text not null default 'medium' check (priority in ('low', 'medium', 'high', 'critical')),
  status text not null default 'pending' check (status in ('pending', 'in_progress', 'completed')),
  due_date timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.reviews (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  session_id text references public.study_sessions(id) on delete set null,
  track_id text references public.study_tracks(id) on delete set null,
  skill_id text references public.study_skills(id) on delete set null,
  title text not null,
  scheduled_for timestamptz not null,
  status text not null default 'pending' check (status in ('pending', 'completed', 'overdue')),
  interval_label text not null,
  notes text,
  completed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.projects (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  track_id text references public.study_tracks(id) on delete set null,
  title text not null,
  scope text not null,
  description text not null default '',
  repository_url text,
  documentation_url text,
  video_url text,
  status text not null default 'planned' check (status in ('planned', 'active', 'blocked', 'completed')),
  progress_percent numeric(5,2) not null default 0 check (progress_percent >= 0 and progress_percent <= 100),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.project_steps (
  id text primary key,
  project_id text not null references public.projects(id) on delete cascade,
  title text not null,
  description text not null default '',
  is_done boolean not null default false,
  sort_order integer not null default 1,
  completed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.study_notes (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  folder_name text not null default 'Geral',
  title text not null,
  content text not null default '',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.flashcards (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  deck_name text not null default 'Geral',
  question text not null,
  answer text not null default '',
  track_id text references public.study_tracks(id) on delete set null,
  module_id text references public.study_modules(id) on delete set null,
  project_id text references public.projects(id) on delete set null,
  due_at timestamptz not null default timezone('utc', now()),
  last_reviewed_at timestamptz,
  review_count integer not null default 0,
  correct_streak integer not null default 0,
  ease_factor numeric(4,2) not null default 2.30,
  interval_days integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.mind_maps (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  folder_name text not null default 'Geral',
  title text not null,
  content_json text not null default '{}',
  track_id text references public.study_tracks(id) on delete set null,
  module_id text references public.study_modules(id) on delete set null,
  project_id text references public.projects(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.sync_queue (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  table_name text not null,
  record_id text not null,
  action text not null check (action in ('upsert', 'delete')),
  payload jsonb not null default '{}'::jsonb,
  attempts integer not null default 0,
  last_error text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.app_settings (
  id text primary key,
  user_id uuid not null unique references auth.users(id) on delete cascade,
  theme_preference text not null default 'dark' check (theme_preference in ('system', 'dark', 'light')),
  notifications_enabled boolean not null default true,
  daily_reminder_hour integer,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists idx_user_goals_user_id on public.user_goals(user_id);
create index if not exists idx_user_skill_progress_user_id on public.user_skill_progress(user_id);
create index if not exists idx_study_sessions_user_id_start_time on public.study_sessions(user_id, start_time desc);
create index if not exists idx_tasks_user_id_status_due_date on public.tasks(user_id, status, due_date);
create index if not exists idx_reviews_user_id_scheduled_for on public.reviews(user_id, scheduled_for);
create index if not exists idx_projects_user_id_status on public.projects(user_id, status);
create index if not exists idx_project_steps_project_id on public.project_steps(project_id);
create index if not exists idx_study_notes_user_id_folder_name on public.study_notes(user_id, folder_name);
create index if not exists idx_flashcards_user_id_due_at on public.flashcards(user_id, due_at);
create index if not exists idx_mind_maps_user_id_folder_name on public.mind_maps(user_id, folder_name);
create index if not exists idx_sync_queue_user_id_created_at on public.sync_queue(user_id, created_at);
create index if not exists idx_study_skills_track_id on public.study_skills(track_id, sort_order);
create index if not exists idx_study_modules_track_id on public.study_modules(track_id, sort_order);

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists set_user_goals_updated_at on public.user_goals;
create trigger set_user_goals_updated_at
before update on public.user_goals
for each row execute function public.set_updated_at();

drop trigger if exists set_study_tracks_updated_at on public.study_tracks;
create trigger set_study_tracks_updated_at
before update on public.study_tracks
for each row execute function public.set_updated_at();

drop trigger if exists set_study_skills_updated_at on public.study_skills;
create trigger set_study_skills_updated_at
before update on public.study_skills
for each row execute function public.set_updated_at();

drop trigger if exists set_user_skill_progress_updated_at on public.user_skill_progress;
create trigger set_user_skill_progress_updated_at
before update on public.user_skill_progress
for each row execute function public.set_updated_at();

drop trigger if exists set_study_modules_updated_at on public.study_modules;
create trigger set_study_modules_updated_at
before update on public.study_modules
for each row execute function public.set_updated_at();

drop trigger if exists set_study_sessions_updated_at on public.study_sessions;
create trigger set_study_sessions_updated_at
before update on public.study_sessions
for each row execute function public.set_updated_at();

drop trigger if exists set_tasks_updated_at on public.tasks;
create trigger set_tasks_updated_at
before update on public.tasks
for each row execute function public.set_updated_at();

drop trigger if exists set_reviews_updated_at on public.reviews;
create trigger set_reviews_updated_at
before update on public.reviews
for each row execute function public.set_updated_at();

drop trigger if exists set_projects_updated_at on public.projects;
create trigger set_projects_updated_at
before update on public.projects
for each row execute function public.set_updated_at();

drop trigger if exists set_project_steps_updated_at on public.project_steps;
create trigger set_project_steps_updated_at
before update on public.project_steps
for each row execute function public.set_updated_at();

drop trigger if exists set_study_notes_updated_at on public.study_notes;
create trigger set_study_notes_updated_at
before update on public.study_notes
for each row execute function public.set_updated_at();

drop trigger if exists set_flashcards_updated_at on public.flashcards;
create trigger set_flashcards_updated_at
before update on public.flashcards
for each row execute function public.set_updated_at();

drop trigger if exists set_mind_maps_updated_at on public.mind_maps;
create trigger set_mind_maps_updated_at
before update on public.mind_maps
for each row execute function public.set_updated_at();

drop trigger if exists set_sync_queue_updated_at on public.sync_queue;
create trigger set_sync_queue_updated_at
before update on public.sync_queue
for each row execute function public.set_updated_at();

drop trigger if exists set_app_settings_updated_at on public.app_settings;
create trigger set_app_settings_updated_at
before update on public.app_settings
for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.email
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.study_tracks enable row level security;
alter table public.study_skills enable row level security;
alter table public.study_modules enable row level security;
alter table public.profiles enable row level security;
alter table public.user_goals enable row level security;
alter table public.user_skill_progress enable row level security;
alter table public.study_sessions enable row level security;
alter table public.tasks enable row level security;
alter table public.reviews enable row level security;
alter table public.projects enable row level security;
alter table public.project_steps enable row level security;
alter table public.study_notes enable row level security;
alter table public.flashcards enable row level security;
alter table public.mind_maps enable row level security;
alter table public.sync_queue enable row level security;
alter table public.app_settings enable row level security;

drop policy if exists "catalog_read_tracks" on public.study_tracks;
create policy "catalog_read_tracks"
on public.study_tracks
for select
to authenticated
using (true);

drop policy if exists "catalog_read_skills" on public.study_skills;
create policy "catalog_read_skills"
on public.study_skills
for select
to authenticated
using (true);

drop policy if exists "catalog_read_modules" on public.study_modules;
create policy "catalog_read_modules"
on public.study_modules
for select
to authenticated
using (true);

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "user_goals_all_own" on public.user_goals;
create policy "user_goals_all_own"
on public.user_goals
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "user_skill_progress_all_own" on public.user_skill_progress;
create policy "user_skill_progress_all_own"
on public.user_skill_progress
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "study_sessions_all_own" on public.study_sessions;
create policy "study_sessions_all_own"
on public.study_sessions
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "tasks_all_own" on public.tasks;
create policy "tasks_all_own"
on public.tasks
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "reviews_all_own" on public.reviews;
create policy "reviews_all_own"
on public.reviews
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "projects_all_own" on public.projects;
create policy "projects_all_own"
on public.projects
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "project_steps_all_own" on public.project_steps;
create policy "project_steps_all_own"
on public.project_steps
for all
to authenticated
using (
  exists (
    select 1
    from public.projects p
    where p.id = project_id
      and p.user_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.projects p
    where p.id = project_id
      and p.user_id = auth.uid()
  )
);

drop policy if exists "study_notes_all_own" on public.study_notes;
create policy "study_notes_all_own"
on public.study_notes
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "flashcards_all_own" on public.flashcards;
create policy "flashcards_all_own"
on public.flashcards
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "mind_maps_all_own" on public.mind_maps;
create policy "mind_maps_all_own"
on public.mind_maps
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "sync_queue_all_own" on public.sync_queue;
create policy "sync_queue_all_own"
on public.sync_queue
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "app_settings_all_own" on public.app_settings;
create policy "app_settings_all_own"
on public.app_settings
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
