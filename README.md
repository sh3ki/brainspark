# BrainSpark

> Flashcard & quiz learning app that turns any subject into a smart, adaptive study system.

---

## Overview

BrainSpark is a mobile learning app that helps users study smarter using spaced-repetition flashcards and timed quiz sessions. Users organize cards into decks by topic, track mastery progress, and review performance analytics — making it effective for students, professionals, and lifelong learners.

---

## Problem

Traditional study methods — re-reading notes and passive review — are inefficient and hard to measure. Learners struggle to identify which topics need more attention and often study material they already know, wasting time before exams or certifications.

---

## Solution

BrainSpark combines active recall with performance tracking. Cards are flagged by difficulty, mastery is computed from accuracy scores, and study sessions surface weak cards more frequently. Users see exactly where they stand after every session and get reminded when it's time to review.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Supabase Auth (email + Google OAuth) |
| Database | Supabase PostgreSQL |
| Storage | Supabase Storage (card images) |
| Backend Logic | Supabase Edge Functions (Deno) |
| Real-time Sync | Supabase Realtime |
| Notifications | flutter_local_notifications |
| Charts | fl_chart |
| Typography | Google Fonts |
| Animations | flutter_staggered_animations |

---

## Features

**Core**
- Deck creation with custom color, emoji, name, and description
- Flashcard editor with front, back, hint, and per-card difficulty rating (Easy / Medium / Hard)
- Flip-card study session with swipe gestures and self-rating
- Timed multiple-choice quiz mode generated from deck content
- Mastery algorithm: cards marked mastered at ≥ 80% accuracy over 3+ reviews
- Adaptive review frequency — harder cards resurface more often

**Backend & Infrastructure**
- Supabase Auth with persistent sessions and token refresh
- Decks and cards stored in Supabase PostgreSQL, scoped per user via Row Level Security (RLS)
- Real-time deck sync across devices via Supabase Realtime subscriptions
- Card images uploaded to Supabase Storage with CDN delivery
- Supabase Edge Function calculates spaced-repetition review intervals server-side
- Offline study mode — local cache for uninterrupted sessions, changes synced on reconnect
- Supabase cron job sends daily review-due counts to the notification service

**Analytics & Progress**
- Per-deck accuracy trends, review history, and mastery percentage
- Weekly study time and quiz score charts via fl_chart
- Daily study goal tracking with streak counter
- Local push notifications for study reminders at user-configured times

**UX**
- Dark / light theme toggle
- Drag-to-reorder cards within decks
- Settings: daily goal, notification schedule, preferred quiz difficulty

---

## Challenges

- Implementing a server-side spaced-repetition scheduler that stays accurate across time zones
- Syncing card completion state in real time without conflicts when studying on two devices simultaneously
- Keeping quiz question generation varied across repeated sessions on the same small deck

---

## Screenshots

_Dashboard · Study Session · Quiz Mode · Progress_
