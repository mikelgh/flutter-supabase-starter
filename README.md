# Flutter Supabase Starter

Flutter + Supabase Auth starter

## Getting Started

This project is a starting point for a Flutter application with Supabase integration. It includes authentication and a basic example of data fetching.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features

*   Supabase Authentication (Sign-in, Sign-up, Sign-out)
*   Basic Data Fetching from Supabase

## Environment Configuration

This project uses the `flutter_dotenv` package to manage environment variables, specifically your Supabase URL and Anon Key.

**Steps to configure your environment:**

1.  **Rename `.env.example`:** Rename the `.env.example` file located in the root of the project to `.env`.

2.  **Open `.env`:** Open the newly renamed `.env` file in your code editor.

3.  **Populate with your Supabase credentials:**  Replace the placeholders for `SUPABASE_URL` and `SUPABASE_ANON_KEY` in the `.env` file. You can find these credentials in your Supabase project dashboard under Settings -> API.

4. **Run the app:**  Run your Flutter app. The `flutter_dotenv` package will automatically load the environment variables from the `.env` file.