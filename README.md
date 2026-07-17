# 🏑 JM Hockey (JMH) Mobile Application

Welcome to the official repository for the **JM Hockey (JMH)** Mobile Application ecosystem. This application serves as a comprehensive athlete development tracking system, an operational backbone for coaches, a vital communication bridge for parents, and an administrative management tool for the academy.

Built as a collaborative team software development project, the system integrates robust multi-role permissions to deliver tailored interfaces and real-time data metrics for different user tiers.

🔗 **Official Website:** [Jiwa Hockey](https://jiwahockey.com)

---

## 👥 The Development Team & Role Distribution

The system architecture is divided across three core modules managed by specific engineering roles:

### 👑 Member 1 (Team Leader) — Hasti Kabiri
**Assigned Focus:** Core System Architecture + Player Module
*   **Authentication & Security:** Robust user sign-up/login backend and role detection logic.
*   **Role-Based Access Control (RBAC):** Dynamic dashboard routing for 5 roles (Player, Parent, Coach, Admin, Performance Analyst).
*   **Player Profile System:** Digital ID generation, medical/injury logging, and institutional profiles.
*   **Engagement & Feedback UI:** Visual widgets for attendance histories, fitness trends, badges/achievements, and coach notes.

### 👥 Member 2 
**Assigned Focus:** Public Module + Parent Dashboard + Basic Admin Panel
*   **Public Branding & Marketing:** Non-authenticated layouts featuring sponsor banners, news streams, galleries, and tournament schedules.
*   **Parent Communication Hub:** Training fee payment tracking, live announcements, and direct child progress summaries.
*   **Admin Panel (v1):** Basic user account CRUD operations and internal administrative dashboards.

### 👥 Member 3 
**Assigned Focus:** Coach Operations + Performance Analyst Module
*   **Coach Management Tools:** Daily attendance marking mechanisms, training session templates, and player report grading grids.
*   **Performance Analytics UI:** Match metric aggregations (goals, turnovers, intercepts) and simplified tracking breakdowns.

---

## 🛠️ Extended Module Architecture Overview

The complete scope of the **JMH System** spans across 8 structural domains:

1.  **Public Module:** Guest-accessible landing zones, partner banners, FIH rulebooks, and public game/clinic registrations.
2.  **Member Core:** Guarded routing engine mapping accounts to their explicit authorization dashboards.
3.  **Player Module:** The athlete ecosystem tracking historical fitness data, Strava integrations, Duke of Edinburgh (DoFE) logs, speed/agility diagnostics, and return-to-play medical logs.
4.  **Parent Module:** Streamlined transactional interface for academic fee processing, tournament calendar synchronization, and progress viewing.
5.  **Coach Module:** Technical operations containing drill asset libraries, tactical boards, and roster team selections.
6.  **Performance Analysis Module:** Granular match tagging interfaces logging circles entries, passing trends, possession zones, and tactical heatmaps.
7.  **E-Commerce Module:** Retail layer tracking product inventory and size configurations for official equipment (sticks, shin guards) and partner gear (OBO Hockey, Lila Sports).
8.  **Web Admin Dashboard:** Unified administrative pane tracking absolute system metrics, payment gateways, and content-delivery settings.

---

## 📅 Project Roadmap & Execution Timeline

The delivery lifecycle is target-locked for **Early August** implementation:

*   **27 June – 5 July:** Comprehensive UI/UX wireframing, component structuring, and Figma prototyping.
*   **6 July – 31 July:** Core sprint phase (Component coding, database layout schemas, backend logic integration).
*   **1 August – 5 August:** Code refactoring, UI polishing, debugging, and final application deployment builds.
*   **10 August – 21 August:** Project Freeze / Academic Examination Period.

---

## 🚀 Compilation, Structure, and Execution Instructions

### 📂 Accessing the Source Code
The core source code and application logic reside in the standard directory tree. You can inspect the application entry point and modular files here:
*   **Main Entry Point:** `lib/main.dart`
*   **Feature Architecture:** All screens, authentication states, and role-based logic are structured dynamically inside the `lib/` directory.

### Prerequisites
Make sure you have the Flutter SDK installed and configured on your machine, along with an active emulator or connected physical testing device.

### Setup & Local Execution
1.  Clone the project repository to your working environment:
    ```bash
    git clone [https://github.com/YOUR_USERNAME/jm-hockey-mobile-app.git](https://github.com/YOUR_USERNAME/jm-hockey-mobile-app.git)
    ```
2.  Navigate directly into the project directory:
    ```bash
    cd jm-hockey-mobile-app
    ```
3.  Fetch and synchronize all project dependencies:
    ```bash
    flutter pub get
    ```
4.  Launch the mobile application on your target device:
    ```bash
    flutter run
    ```

---
*Disclaimer: This system is built as a collaborative academic application submission. All vendor integrations, e-commerce checkouts, and medical forms operate under sandbox test environments.*
