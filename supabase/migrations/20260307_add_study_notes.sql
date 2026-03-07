create table if not exists public.study_notes (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  folder_name text not null default 'Geral',
  title text not null,
  content text not null default '',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists idx_study_notes_user_id_folder_name
on public.study_notes(user_id, folder_name);

drop trigger if exists set_study_notes_updated_at on public.study_notes;
create trigger set_study_notes_updated_at
before update on public.study_notes
for each row execute function public.set_updated_at();

alter table public.study_notes enable row level security;

drop policy if exists "study_notes_all_own" on public.study_notes;
create policy "study_notes_all_own"
on public.study_notes
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
