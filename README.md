# Abundance

A monthly budget and expense tracker you can install on your phone and use on your laptop. Your data lives in your own Supabase database and syncs live between devices.

**What's in this folder**

| File | What it is |
|---|---|
| `index.html` | The whole app |
| `config.js` | Your Supabase connection settings (you fill this in) |
| `supabase/schema.sql` | Creates the database tables and security rules |
| `sw.js`, `manifest.webmanifest`, `icon-*.png` | Make it installable on your phone |
| `vercel.json` | Hosting settings for Vercel |

Setup takes about 15 minutes. You need a free Supabase account, a free Vercel account and a free GitHub account.

---

## 1. Create the database (Supabase)

1. Go to <https://supabase.com>, sign up and click **New project**.
   - Name: `abundance`
   - Database password: generate one and save it somewhere safe
   - Region: **Mumbai (ap-south-1)** for the fastest response in India
2. When the project is ready, open **SQL Editor → New query**.
3. Paste the whole of `supabase/schema.sql` and click **Run**. You should see "Success. No rows returned".
4. Open **Project Settings → API** and copy two values:
   - **Project URL** (looks like `https://abcdxyz.supabase.co`)
   - **anon public** key (a long string starting with `eyJ`)

## 2. Connect the app to the database

Open `config.js` and replace the two placeholders:

```js
window.ABUNDANCE_CONFIG = {
  supabaseUrl: "https://abcdxyz.supabase.co",
  supabaseAnonKey: "eyJhbGciOi..."
};
```

The anon key is meant to be public. The security rules from step 1 make sure each signed-in person can only ever see their own data. Never put the **service_role** key in this file.

## 3. Put it online (Vercel)

1. Create a new **private** repository on GitHub and upload everything in this folder (drag and drop on the GitHub website works).
2. Go to <https://vercel.com>, sign in with GitHub, click **Add New → Project** and import that repository.
3. Framework preset: **Other**. Leave the build command and output directory empty. Click **Deploy**.
4. Vercel gives you an address like `https://abundance-yourname.vercel.app`. Copy it.

Any change you push to GitHub later redeploys automatically.

## 4. Tell Supabase your app's address

So that email confirmation and password-reset links open your app:

1. In Supabase, open **Authentication → URL Configuration**.
2. Set **Site URL** to your Vercel address, for example `https://abundance-yourname.vercel.app`.
3. Under **Redirect URLs**, add the same address.

## 5. Create your account

1. Open your Vercel address and choose **Create account**.
2. Enter your email and a password of at least 8 characters.
3. Open the confirmation email from Supabase and tap the link. You'll be signed in.

Supabase's built-in email service sends only a few emails per hour, which is plenty for one person. If you'd rather skip email confirmation, turn off **Authentication → Sign In / Providers → Email → Confirm email**.

## 6. Install it on your phone

- **iPhone (Safari):** open your app address → Share button → **Add to Home Screen**.
- **Android (Chrome):** open your app address → **⋮** menu → **Install app** (or **Add to Home screen**).

It opens full screen like a normal app. Sign in once on each device and everything stays in sync.

---

## Using it

- **Budget tab:** set a monthly total and split it into categories.
- **Expenses tab:** log the amount, what it was for, the category and the date.
- **Analytics tab:** month-end projection, spending pace, category breakdown, category health and a six-month trend.
- **Account button (your initial, top right):** export all expenses to CSV, or sign out.
- **Palette and light/dark buttons:** these are remembered on each device.

## Good to know

- **Backups:** use **Export expenses (CSV)** from time to time. Supabase's free plan doesn't include automatic backups you can restore from yourself.
- **Free plan pause:** Supabase pauses free projects after about a week with no activity. If that happens, open the Supabase dashboard and click **Restore**. Your data is kept.
- **Changing colours or features:** edit `index.html`, push to GitHub, and Vercel redeploys within a minute.

## How your data is stored

| Table | Contents |
|---|---|
| `settings` | One row per person: monthly budgets and categories as JSON |
| `expenses` | One row per expense: amount, what it was for, date, month and category id |

You can view and query both tables in Supabase under **Table Editor**.
