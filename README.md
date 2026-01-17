# 📱 QuoteVault — Flutter + Supabase Quote App

QuoteVault is a full-featured quote discovery and collection app built using **Flutter**, **Riverpod**, and **Supabase**.  
It supports authentication, quote browsing, favorites, collections, daily quotes, theming, and cloud sync.

This project demonstrates **clean architecture**, **state management**, and **backend integration** suitable for production apps.

---

## 🚀 Features Overview

### 🔐 Authentication
- Email & Password login/signup
- Supabase Auth integration
- AuthGate for session handling
- Secure logout
- Session persistence

### 📖 Quotes
- Browse 120+ quotes
- Filter by category (Motivation, Love, Success, Wisdom, Humor)
- “All” category
- Search quotes
- Pull-to-refresh
- Quote of the Day (server-persisted)

### ❤️ Favorites
- Add/remove favorites
- Cloud-synced per user
- Favorites screen
- Realtime UI update with Riverpod

### 📂 Collections
- Create collections with color picker
- Add/remove quotes to collections
- One quote → multiple collections (many-to-many)
- Collection details screen
- Search inside collections
- Persistent storage using join table

### 🎨 Personalization
- Light / Dark theme
- Accent color picker
- Font size adjustment
- Theme persistence

### 📤 Share
- Share quote as text
- Share quote as image (widget snapshot)

---

## 🧱 Tech Stack

| Layer | Technology |
|---|---|
Frontend | Flutter (Material 3) |
State Management | Riverpod |
Backend | Supabase (Auth + Postgres) |
Auth | Supabase Auth |
Database | Supabase Postgres |
Architecture | Feature-first, controller-driven |

---

## 🔄 App Flow (High Level)

App Start
↓
SplashScreen
↓
AuthGate
├── Logged In → HomeScreen
└── Logged Out → LoginScreen


- **AuthGate** listens to Supabase `onAuthStateChange`
- Logout automatically redirects to Login

---

## 🧠 State Management (Riverpod)

### Controllers Used
- `authControllerProvider`
- `homeControllerProvider`
- `favoritesControllerProvider`
- `collectionsControllerProvider`
- `themeProvider`

### Why Riverpod?
- Compile-time safety
- AsyncValue handling
- Clear separation of UI & logic
- Easy testing

---

## 🗄️ Supabase Database Schema

### 🔹 quotes
```sql
id uuid primary key
text text
author text
category text
created_at timestamp
```

### 🔹 favorites
```sql 
user_id uuid
quote_id uuid
unique(user_id, quote_id)
```

### 🔹 collections
```sql 
quote_id uuid
day date unique
```
