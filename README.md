# DeutschKompass – Deutsch lernen A1 bis B2

A responsive German-learning app with username/password sign-in, an onboarding questionnaire, a personalized daily/weekly study plan, level-based practice tests, writing prompts, reading and listening comprehension, grammar, vocabulary, and saved progress.

## Project files

- `index.html` – app shell
- `style.css` – responsive interface
- `app.js` – Supabase authentication, onboarding, exercises, scoring and progress
- `supabase/schema.sql` – database schema and row-level security

## Supabase setup

This app uses the existing **NEXYRON** project. The frontend uses its public publishable key; never put a service-role or secret key in browser code.

1. In Supabase Authentication → Providers → Email, keep email/password sign-in enabled and turn **Confirm email** off. The app maps each chosen username to a hidden synthetic address ending in `@accounts.deutschkompass.invalid`, so users do not enter an email address.
2. Run `supabase/schema.sql` in the NEXYRON SQL Editor. The four tables are separate from the project's existing game and chat tables.
3. In the Supabase API settings, make sure these new public tables are exposed to the Data API: `deutsch_profiles`, `deutsch_plans`, `deutsch_attempts`, and `deutsch_vocab`. Their grants and RLS policies are already included in the SQL.
4. Enable GitHub Pages for the repository, using the `main` branch and root folder.

## Important account note

Because login is deliberately email-free, password recovery by email is not available in this first version. Users must keep their password safe. A production release should add a verified recovery method or a username recovery flow before inviting a large audience.

## Learning and scoring note

The first version includes CEFR-level task banks and a deterministic writing rubric. Writing feedback currently checks text length and selected structure signals; it is not an AI grammar correction and should not be presented as an official telc/Goethe result. Listening exercises use the browser's German text-to-speech voice.
