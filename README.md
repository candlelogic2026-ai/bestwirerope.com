# BestWireRope.com

Website for VARADHA INDUSTRIAL PRODUCTS AND SUPPLIES.

Phone/WhatsApp: +91 9696968631
Email: ips16418@gmail.com
Address: 4-2-109, Old Bhoiguda, Secunderabad, Hyderabad, Telangana, 500003

## 1. GitHub
1. Create a new GitHub repository named `bestwirerope.com` (Public is easiest for GitHub Pages).
2. Upload all files from this folder to the repository root. Do not upload the ZIP itself inside the repo.
3. In Settings > Pages, choose Deploy from a branch, branch `main`, folder `/ (root)`, Save.
4. Keep the included `CNAME` file. It contains `bestwirerope.com`.
5. In your domain DNS, create:
   - A @ -> 185.199.108.153
   - A @ -> 185.199.109.153
   - A @ -> 185.199.110.153
   - A @ -> 185.199.111.153
   - CNAME www -> your-github-username.github.io
6. After DNS propagates, return to GitHub Pages and enable HTTPS.

## 2. Supabase
1. Open your existing Supabase project `Industrial Products`.
2. Create an Authentication user for the website admin. Use your preferred admin email and a strong password.
3. Open SQL Editor and run `supabase-setup.sql` from this package.
4. Copy the new user's UUID from Authentication > Users and run the final INSERT shown at the bottom of the SQL file.
5. Get Project URL and Publishable key from Project Settings > API.
6. Open `assets/config.js` and replace the two placeholders with the Project URL and Publishable key. Leave `storageBucket` as `bestwirerope-images`.
7. Commit the changed `assets/config.js` to GitHub.
8. Open `https://bestwirerope.com/admin.html` and sign in.

### Security
Never put the Supabase service-role/secret key in this website. The browser must use the publishable key only. RLS and the `site_admins` table control admin writes.

## 3. Daily use
- Add a product in `/admin.html` and upload multiple photos.
- Add a customer solution story every day with problem, solution, products and photos.
- Published content automatically appears on the public site.
- Images stay in Supabase Storage, so changing GitHub website code does not delete them.
