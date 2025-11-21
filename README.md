🚀 Mini Lead Manager App



1. App Overview 🎯

This project is a small CRM-style Lead Management App built with Flutter to evaluate practical skills in UI, state management, persistent storage, and clean architecture.


Core Functionality
The application allows a user to perform full CRUD operations on lead records:

Add new leads with required Name and Contact details, and optional Notes .

View all leads in a scrollable list, displaying Lead Name, Contact, and Status .

Filter leads quickly by status: All, New, Contacted, Converted, or Lost .

View details of a specific lead and perform updates to information or status .

Delete leads permanently.

Persistent Data Storage is ensured using sqflite.



Implemented Bonus Features ✨

The following optional features were implemented for extra credit, enhancing UX and application utility :


Search Leads by Name: Allows users to quickly find leads in the list.

Theme Change: Support for dynamic Light/Dark theme switching.

Export Leads as JSON file: Leads can be exported/shared via the share_plus package.

UI Polish: Custom StatusBadge and StatusChip widgets for clean, informative display.


2. How to Run ⚙️

Prerequisites

Flutter SDK: The project was developed using the stable channel (version 3.35.5).

Dart SDK: (version  3.9.2 )

An IDE (VS Code or Android Studio) with the Flutter/Dart plugins installed.


Steps to Execute

Clone the Repository:

git clone (https://github.com/gudhate-shravani/flutter_lead_management_app.git)

cd lead_management_app

Install Dependencies: 
Run the following command in the project root:



flutter pub get

Run the App: Ensure an active device or emulator is running, then execute:

flutter run




3. Architecture Explanation 🧱

This project adheres to a Clean, Layered Architecture, promoting separation of concerns , code modularity , and reusability.



Project Structure

The structure follows the defined best practices:

lib/models/: Contains the primary data structure, lead_model.dart.

lib/providers/: Houses the state management logic (lead_provider.dart), adhering to proper state management usage.

lib/screens/: Contains all main UI pages, including lead_list_screen.dart and add_lead_screen.dart.

lib/services/: The core business logic layer. database_service.dart encapsulates all data source interactions.

lib/widgets/: Stores reusable UI components like lead_card.dart and status_badge.dart.




State Management: Provider
Chosen Tool: Provider.

Usage: The LeadProvider acts as the single source of truth for the list of leads. It exposes methods for fetching, filtering, and performing all CRUD operations, effectively decoupling the UI from the business and data layers.

Local Persistent Storage: sqflite
Chosen Tool: SQLite via the sqflite package.


Implementation: The DatabaseService handles all interactions, ensuring reliable CRUD operations and data persistence  by managing the database creation, connection, and queries.



4. Packages Used 📦
The following key external dependencies were used, as defined in pubspec.yaml:

provider: Core package for state management.

sqflite: Primary package for local persistent data storage (SQLite).

path_provider: Used to find and manage the database file location on the device.

share_plus: Used to facilitate the export/sharing of lead data (JSON export bonus feature).

intl: Used for number, date, or currency formatting (if applicable).
