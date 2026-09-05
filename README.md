# 🌾 Kisan Bazaar — Flutter Agricultural Marketplace

A mobile-first digital marketplace that connects farmers and buyers for agricultural produce (vegetables, fruits, grains, dairy, organic). Built with Flutter + Provider, fully offline-capable, and packaged as an installable Android APK.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![APK](https://img.shields.io/badge/Download-APK-blue?logo=android&logoColor=white)](#installation)

## What it does

Kisan Bazaar solves a real problem: small farmers need a simple, low-data way to list and sell produce without depending on intermediaries. The app runs completely offline — product data ships as bundled JSON, images are stored locally, and user sessions persist via SharedPreferences.

Demo account: `demo@kisaan.in` / `demo123`

## Key features

- Offline-first product catalogue (26 products across 5 categories)
- Real-time search and category filtering
- Shopping cart with quantity controls and live totals
- Order history with status tracking
- Dark/light theme toggle
- Form-validated auth with session persistence
- Material Design 3 with green seed theme

## Architecture

```
app/
  assets/
    json/products.json      # 26-product catalogue
    images/                 # 26 bundled product photos
  lib/
    models/                 # Product, CartItem, Order, AppUser
    data/                   # ProductRepository (rootBundle JSON)
    providers/              # Auth, Cart, Orders, Theme, Products
    screens/                # 9 screens: Splash, Login, Register, Home,
                            # Search, ProductDetail, Cart, Orders, Profile
    widgets/                # Reusable UI components
    main.dart               # Provider wiring + Material 3 theme
  test/                     # Widget + unit tests
  docs/                     # Proposal, report, presentation, viva prep
```

## How to run

```bash
cd app
flutter pub get
flutter analyze        # static analysis (0 issues)
flutter test           # widget + unit tests (all passing)
flutter run            # on a connected device / emulator
flutter build apk --release
```

## Tech stack

- Flutter 3.x · Dart · Material Design 3
- Provider (state management)
- SharedPreferences (session persistence)
- JSON asset loading (offline data)
- intl (date formatting)

## Installation

Download the APK from the [Releases page](https://github.com/ShriVansh919/Farmer-Marketplace/releases/tag/v1.0.0) and install it on any Android device. You may need to enable "Install from unknown sources" in your settings.

## Deliverables

- Project proposal and final report (DOCX)
- Slide presentation (PPTX)
- Demo script and viva preparation guide (Markdown)
