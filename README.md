# 🌾 Kisan Bazaar — Flutter Agricultural Marketplace

[![Download APK](https://img.shields.io/badge/Download-APK-blue?logo=android&logoColor=white&style=for-the-badge)](#download-the-app)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

A classroom Flutter project: a mobile-first digital marketplace for agricultural
produce (vegetables, fruits, grains, dairy, organic). Built with Flutter + Provider,
fully local & offline — products load from bundled JSON, images ship with the app,
and session/order state persist via SharedPreferences.

> Demo account: `demo@kisaan.in` / `demo123`

---

## 📲 Download the app

**[⬇️ Download KisanBazaar.apk](https://github.com/ShriVansh919/Farmer-Marketplace/releases/download/v1.0.0/KisanBazaar.apk)**

The latest installable Android build (v1.0.0) is published as a GitHub Release asset.
Install it on any Android phone/emulator and start browsing produce.

> ⚠️ You'll see a "install from unknown source" prompt — this is a self-signed classroom
> build, so allow the install from your browser/file manager.

---

## Features
- Splash screen with session restore
- Register / Login with form validation (seeded demo account `demo@kisaan.in` / `demo123`)
- Home: branding header, search bar, promo banner, category chips, featured product grid
- Search tab with real-time keyword filtering
- Product catalogue (26 products across 5 categories) with details screen and bundled images
- Cart: add/remove, quantity +/-, live totals, checkout dialog
- Orders: persisted order history with status
- Profile: user details, dark-theme toggle, logout

## Team structure
| #  | Module               | Responsibility                                                |
|----|----------------------|---------------------------------------------------------------|
| 1  | Authentication       | Splash, Login, Register, Logout, SharedPreferences session    |
| 2  | Home                 | Dashboard, Search bar, Categories, Featured, Bottom navigation|
| 3  | Products             | List, Details, Dummy JSON, Product model, FutureBuilder       |
| 4  | Cart & Orders        | Cart, Checkout, Orders, Quantity +/-, Total (Provider)        |
| 5  | Profile & Integration| Profile, Theme, Final testing, Git/GitHub merge               |

## Tech stack
**Flutter · Dart · Material Design 3 · Provider · SharedPreferences · JSON · Git/GitHub** — plus `intl` for date formatting.

## Screens
9 screens: Splash · Login · Register · Home · Search · Product Details · Cart · Orders · Profile.

## How to run
```sh
cd app
flutter pub get
flutter analyze        # static analysis (0 issues)
flutter test           # widget + unit tests (all passing)
flutter run            # on a connected device / emulator
flutter build apk --release
```

## Project layout
```
app/
  assets/
    json/products.json   # 26-product catalogue (vegetables, fruits, grains, dairy, organic)
    images/              # 26 bundled product photos (offline-safe)
  lib/
    models/              # Product, CartItem, Order, AppUser
    data/                # ProductRepository (rootBundle JSON load)
    providers/           # Auth, Cart, Orders, Theme, Products
    screens/             # Splash, Login, Register, Home, Search,
                         # ProductDetail, Cart, Orders, Profile
    widgets/             # ProductCard, ProductGrid, CategoryChip, PromoBanner,
                         # AuthHeader, ProductThumb, Empty/Error state views
    main.dart            # Provider wiring + Material 3 theme (green seed)
  test/widget_test.dart  # model/cart unit tests + splash smoke test
docs/                    # Project_Proposal, Final_Report, Presentation,
                         # DEMO_SCRIPT.md, VIVA_PREP.md
```

## Docs & deliverables
- `docs/Project_Proposal.docx`
- `docs/Final_Report.docx` (includes testing matrix and team table)
- `docs/Presentation.pptx`
- `docs/DEMO_SCRIPT.md` (shot-by-shot demo video script)
- `docs/VIVA_PREP.md` (20 viva questions with answers)