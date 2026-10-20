create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username VARCHAR(255) not null,
  full_name VARCHAR(255) not null,
  email VARCHAR(255) not null,
);

grant select, insert, update on public.profiles to authenticated;