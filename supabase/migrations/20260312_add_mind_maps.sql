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

create index if not exists idx_mind_maps_user_id_folder_name
on public.mind_maps(user_id, folder_name);

drop trigger if exists set_mind_maps_updated_at on public.mind_maps;
create trigger set_mind_maps_updated_at
before update on public.mind_maps
for each row execute function public.set_updated_at();

alter table public.mind_maps enable row level security;

drop policy if exists "mind_maps_all_own" on public.mind_maps;
create policy "mind_maps_all_own"
on public.mind_maps
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
