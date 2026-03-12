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

create index if not exists idx_flashcards_user_id_due_at
on public.flashcards(user_id, due_at);

drop trigger if exists set_flashcards_updated_at on public.flashcards;
create trigger set_flashcards_updated_at
before update on public.flashcards
for each row execute function public.set_updated_at();

alter table public.flashcards enable row level security;

drop policy if exists "flashcards_all_own" on public.flashcards;
create policy "flashcards_all_own"
on public.flashcards
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
