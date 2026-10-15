<<<<<<< HEAD
# ग्रंथालय (Granthalay) — Library Management System (Flutter Frontend)

**ग्रंथालय** is an Android-first, bilingual (मराठी & English) Library Management System frontend developed in Flutter and Dart using Material Design 3. It is designed to manage approximately 2,000 library books and provide daily operational tools for a library librarian.

The application operates completely offline in **Interactive Demo Mode** with realistic Marathi and English sample data, while following a clean **Repository & Service Pattern** fully prepared for future integration with a **Spring Boot REST API**.

---

## 🚀 Key Features

1. **Bilingual Localization (मराठी / English)**:
   - Default language: **मराठी (Marathi)**.
   - Instant language switching without restarting the app.
   - Persisted in `SharedPreferences`.
   - Real Marathi book titles and author names remain untouched while UI labels, buttons, forms, and dialogs dynamically update.
   - Configured with `lib/l10n/app_mr.arb` and `lib/l10n/app_en.arb`.

2. **Typography & Styling**:
   - Modern Material 3 styling with clean surfaces, rounded cards (14-16px radius), and high-contrast readable layouts.
   - Deep Royal Blue primary (`#1E3A8A`) with Teal (`#0D9488`) and Emerald Green accents.
   - Native Devanagari typography chain (`Noto Sans Devanagari` / `Mangal` / `Nirmala UI`) ensuring crisp Marathi rendering, proper matras, and conjuncts.

3. **17 Complete Working Screens**:
   - **Screen 1: Splash Screen** — Animated branding with dual language title and subtitle.
   - **Screen 2: Login Screen** — Librarian demo login flow, show/hide password, and direct language switcher.
   - **Screen 3: Dashboard** — 6 dynamic statistics cards, quick actions, and live recent transactions.
   - **Screen 4: Books Directory** — Real-time search, availability and category filters, sorting, and book cards.
   - **Screen 5: Add/Edit Book** — Dual Marathi & English book title/author inputs, copies validation, and category picker.
   - **Screen 6: Book Details** — Comprehensive book metadata, copies counter, and direct Issue, Edit, and Delete actions.
   - **Screen 7: Members Directory** — Search by Marathi/English name, phone number, and member code.
   - **Screen 8: Add/Edit Member** — Member code, dual name support, contact details, and department.
   - **Screen 9: Member Details** — Profile view, currently borrowed books, previously returned count, and action shortcuts.
   - **Screen 10: Issue Book Wizard** — 4-step wizard (Select Member → Select Book → Select Dates → Confirm) with automatic copy decrement.
   - **Screen 11: Return Book** — Search active issued records, confirmation dialog, return date timestamping, and copy increment.
   - **Screen 12: Search Person** — Prominent dual-language search bar with quick suggestion tags ("राहुल पाटील", "Rahul Patil", "M001") and direct history navigation.
   - **Screen 13: Borrowing History** — Complete member transaction timeline with tab filters (All, Issued, Returned, Overdue) and overdue day counter.
   - **Screen 14: Currently Issued Books** — Live list of active book borrowings with due date tracking.
   - **Screen 15: Overdue Books** — Warning badges, calculated days overdue, and instant return action.
   - **Screen 16: Library Reports** — Visual metrics, circulation statistics, and book category distribution bars.
   - **Screen 17: Settings** — Language toggle (मराठी / English), library info, Spring Boot REST API configuration, and logout.

---

## 📁 Project Folder Structure

```
d:/Granthalay/
├── android/                        # Android project configuration & Manifest
├── assets/                         # Static assets (fonts, icons)
├── lib/
│   ├── main.dart                   # Application entry point
│   ├── app.dart                    # MaterialApp, theme, routing, & localizations
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart     # Palette (Deep blue, teal, emerald, alerts)
│   │   │   └── app_constants.dart  # Constants, storage keys, categories
│   │   ├── theme/
│   │   │   └── app_theme.dart      # Material 3 theme & Devanagari typography
│   │   ├── localization/
│   │   │   └── locale_provider.dart# Reactive locale switcher with SharedPreferences
│   │   └── routing/
│   │       └── app_routes.dart     # Named route identifiers
│   ├── data/
│   │   └── demo_data.dart          # Rich Marathi & English sample data
│   ├── models/
│   │   ├── book.dart               # Book model with dual titles & JSON serialization
│   │   ├── member.dart             # Member model with dual names & JSON serialization
│   │   ├── borrow_record.dart      # Borrow record with status & overdue calculations
│   │   └── dashboard_stats.dart    # Aggregated KPI statistics model
│   ├── services/
│   │   └── api_service.dart        # HTTP client for future Spring Boot REST API
│   ├── repositories/
│   │   ├── book_repository.dart    # Book CRUD & copy counter management
│   │   ├── member_repository.dart  # Member CRUD & multi-field search
│   │   └── borrowing_repository.dart# Issue, return, history, & dashboard metrics
│   ├── screens/
│   │   ├── splash/splash_screen.dart
│   │   ├── auth/login_screen.dart
│   │   ├── main_layout.dart        # 5-tab BottomNavigationBar host
│   │   ├── dashboard/dashboard_screen.dart
│   │   ├── books/
│   │   │   ├── books_list_screen.dart
│   │   │   ├── book_details_screen.dart
│   │   │   └── add_edit_book_screen.dart
│   │   ├── members/
│   │   │   ├── members_list_screen.dart
│   │   │   ├── member_details_screen.dart
│   │   │   └── add_edit_member_screen.dart
│   │   ├── issue_return/
│   │   │   ├── transactions_hub_screen.dart
│   │   │   ├── issue_book_screen.dart
│   │   │   ├── return_book_screen.dart
│   │   │   ├── currently_issued_screen.dart
│   │   │   └── overdue_books_screen.dart
│   │   ├── search/search_person_screen.dart
│   │   ├── history/borrowing_history_screen.dart
│   │   ├── reports/reports_screen.dart
│   │   └── settings/settings_screen.dart
│   ├── widgets/
│   │   ├── app_drawer.dart         # Side navigation menu
│   │   ├── app_bottom_navigation.dart# Material 3 bottom navigation bar
│   │   ├── custom_card.dart        # Rounded card container
│   │   ├── statistic_card.dart     # Interactive KPI card
│   │   ├── search_field.dart       # Search bar with clear button
│   │   ├── status_badge.dart       # Available, Issued, Returned, Overdue tags
│   │   ├── empty_state.dart        # Clean empty illustrations
│   │   └── loading_view.dart       # Loading spinner
│   └── l10n/
│       ├── app_mr.arb              # Marathi localization dictionary (Default)
│       ├── app_en.arb              # English localization dictionary
│       └── generated/              # Compiled AppLocalizations classes
├── test/
│   ├── unit_test.dart              # Repository, search, issue/return tests
│   └── widget_test.dart            # Smoke and localization widget tests
├── l10n.yaml                       # Flutter localization configuration
└── pubspec.yaml                    # Dependencies & Flutter project settings
```

---

## 🛠️ Commands to Run the Application

### 1. Ensure Flutter SDK Path is Set
```powershell
$env:PATH = "D:\flutterdev\sdk\bin;$env:PATH"
```

### 2. Install Dependencies
```powershell
flutter pub get
```

### 3. Generate Localizations (if ARB files are modified)
```powershell
flutter gen-l10n
```

### 4. Run Static Analysis & Tests
```powershell
flutter analyze
flutter test
```
*Current test suite: 6/6 tests passing (100%), 0 analysis issues.*

### 5. Run the Application Locally
- **On connected Android device or emulator**:
  ```powershell
  flutter run
  ```
- **On Chrome (Web preview)**:
  ```powershell
  flutter run -d chrome
  ```
- **On Windows desktop**:
  ```powershell
  flutter run -d windows
  ```

---

## 📱 Generating and Installing the Android Release APK

### 1. Build Command
Run the following command from the project root:
```powershell
flutter build apk --release
```

### 2. Output Location
Upon completion, the release APK file is generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 3. Installing on an Android Phone
1. **Via USB Cable**:
   - Copy `app-release.apk` to your phone's storage.
   - On your phone, tap the file in File Manager and select **Install**.
   - If prompted, enable **Allow from this source** in Android Settings.
2. **Via ADB (Command Line)**:
   ```powershell
   adb install -r build/app/outputs/flutter-apk/app-release.apk
   ```

---

## 🔌 Future Spring Boot REST API Integration

The application has been constructed with a clean architecture that completely isolates demo data from the UI layer through repository contracts (`BookRepository`, `MemberRepository`, `BorrowingRepository`) and `ApiService`.

### Prepared API Endpoints:
| HTTP Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/books` | Fetch all books |
| `GET` | `/api/books/{id}` | Fetch book by ID |
| `POST` | `/api/books` | Add new book |
| `PUT` | `/api/books/{id}` | Update book details |
| `DELETE` | `/api/books/{id}` | Delete book |
| `GET` | `/api/members` | Fetch all members |
| `GET` | `/api/members/{id}` | Fetch member by ID |
| `POST` | `/api/members` | Register new member |
| `PUT` | `/api/members/{id}` | Update member details |
| `GET` | `/api/members/search?q={query}` | Search members |
| `POST` | `/api/borrow-records/issue` | Issue a book to a member |
| `POST` | `/api/borrow-records/{id}/return` | Record book return |
| `GET` | `/api/members/{id}/borrow-history` | Member borrowing timeline |
| `GET` | `/api/borrow-records/issued` | Currently issued records |
| `GET` | `/api/borrow-records/overdue` | Overdue borrowing records |
| `GET` | `/api/dashboard/statistics` | Dashboard metrics |

To switch from Demo Mode to a live backend:
1. Open the **Settings Screen** in the app.
2. Toggle off **Demo Mode**.
3. Enter your Spring Boot Base URL (e.g., `http://10.0.2.2:8080/api` for emulator or `http://192.168.1.X:8080/api` for physical device).
4. Tap **Test API Connection**.
=======
# Granthalay
for library management system
>>>>>>> 1d807ce9539ba5e3b8a0c9bb25aab22d20f1fee7
