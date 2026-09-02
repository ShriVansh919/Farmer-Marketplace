# Kisan Bazaar — Flutter Agricultural Marketplace

A classroom Flutter project: a mobile-first digital marketplace for agricultural
produce (vegetables, fruits, grains, dairy, organic). Built with Flutter + Provider,
fully local — products load from bundled JSON, session and order state persist via
SharedPreferences.

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
Flutter · Dart · Material Design 3 · Provider · SharedPreferences · JSON · Git/GitHub

## How to run
```sh
export JAVA_HOME="$HOME/flutter/toolchain/jdk"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$HOME/flutter/toolchain/flutter/bin:$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"

cd app
flutter pub get
flutter analyze        # static analysis
flutter test           # widget + unit tests
flutter run            # on a connected device / emulator
flutter build apk --release
```

## Project layout
```
app/
  assets/json/products.json   # catalogue data (recovered from original app APK)
  lib/
    models/                   # Product, CartItem, Order, AppUser
    data/                     # ProductRepository (rootBundle JSON load)
    providers/                # Auth, Cart, Orders, Theme, Products
    screens/                  # Splash, Login, Register, Home, Search,
                              # ProductDetail, Cart, Orders, Profile
    widgets/                  # ProductCard, CategoryChip, PromoBanner, ProductGrid
    main.dart                 # Provider wiring + Material 3 theme (green seed)
  test/widget_test.dart       # model/cart unit tests + splash smoke test
docs/                         # Project_Proposal, Final_Report, Presentation,
                              # DEMO_SCRIPT.md, VIVA_PREP.md
```

## Docs & deliverables
- `docs/Project_Proposal.docx`
- `docs/Final_Report.docx` (includes testing matrix and team table)
- `docs/Presentation.pptx`
- `docs/DEMO_SCRIPT.md` (shot-by-shot demo video script)
- `docs/VIVA_PREP.md` (20 viva questions with answers)