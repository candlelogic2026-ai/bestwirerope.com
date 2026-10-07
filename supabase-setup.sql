-- BESTWIREROPE.COM SUPABASE SETUP
-- Run this in Supabase Dashboard > SQL Editor AFTER creating the project/admin user.
-- This does not expose the service-role key. The website uses only the publishable key.

create table if not exists public.site_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.site_admins enable row level security;
drop policy if exists "Admins can read own admin row" on public.site_admins;
create policy "Admins can read own admin row" on public.site_admins for select to authenticated using (user_id = (select auth.uid()));

-- Make the image bucket public for website display.
insert into storage.buckets (id, name, public)
values ('bestwirerope-images','bestwirerope-images',true)
on conflict (id) do update set public = true;

-- Admin write access to content tables.
DROP POLICY IF EXISTS "Admins insert products" ON public.products;
DROP POLICY IF EXISTS "Admins update products" ON public.products;
DROP POLICY IF EXISTS "Admins delete products" ON public.products;
CREATE POLICY "Admins insert products" ON public.products FOR INSERT TO authenticated WITH CHECK (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
CREATE POLICY "Admins update products" ON public.products FOR UPDATE TO authenticated USING (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid()))) WITH CHECK (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
CREATE POLICY "Admins delete products" ON public.products FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));

DROP POLICY IF EXISTS "Admins insert solutions" ON public.customer_solutions;
DROP POLICY IF EXISTS "Admins update solutions" ON public.customer_solutions;
DROP POLICY IF EXISTS "Admins delete solutions" ON public.customer_solutions;
CREATE POLICY "Admins insert solutions" ON public.customer_solutions FOR INSERT TO authenticated WITH CHECK (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
CREATE POLICY "Admins update solutions" ON public.customer_solutions FOR UPDATE TO authenticated USING (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid()))) WITH CHECK (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
CREATE POLICY "Admins delete solutions" ON public.customer_solutions FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));

DROP POLICY IF EXISTS "Admins insert product images" ON public.product_images;
DROP POLICY IF EXISTS "Admins delete product images" ON public.product_images;
CREATE POLICY "Admins insert product images" ON public.product_images FOR INSERT TO authenticated WITH CHECK (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
CREATE POLICY "Admins delete product images" ON public.product_images FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));

DROP POLICY IF EXISTS "Admins insert solution images" ON public.solution_images;
DROP POLICY IF EXISTS "Admins delete solution images" ON public.solution_images;
CREATE POLICY "Admins insert solution images" ON public.solution_images FOR INSERT TO authenticated WITH CHECK (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
CREATE POLICY "Admins delete solution images" ON public.solution_images FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));

-- Storage: public can read; only listed admins can write/delete.
DROP POLICY IF EXISTS "Public read BestWireRope images" ON storage.objects;
CREATE POLICY "Public read BestWireRope images" ON storage.objects FOR SELECT TO public USING (bucket_id='bestwirerope-images');
DROP POLICY IF EXISTS "Admins upload BestWireRope images" ON storage.objects;
CREATE POLICY "Admins upload BestWireRope images" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id='bestwirerope-images' AND EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
DROP POLICY IF EXISTS "Admins update BestWireRope images" ON storage.objects;
CREATE POLICY "Admins update BestWireRope images" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id='bestwirerope-images' AND EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid()))) WITH CHECK (bucket_id='bestwirerope-images' AND EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));
DROP POLICY IF EXISTS "Admins delete BestWireRope images" ON storage.objects;
CREATE POLICY "Admins delete BestWireRope images" ON storage.objects FOR DELETE TO authenticated USING (bucket_id='bestwirerope-images' AND EXISTS (SELECT 1 FROM public.site_admins a WHERE a.user_id=(select auth.uid())));

-- IMPORTANT: after creating the admin user in Authentication > Users, replace this UUID and run:
-- insert into public.site_admins(user_id) values ('YOUR-AUTH-USER-UUID');
