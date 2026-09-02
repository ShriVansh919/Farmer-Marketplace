# Kisan Bazaar — Viva Preparation

## Flutter / Dart
1. **What is Flutter?** — Google's open-source UI toolkit; one Dart codebase compiles to native
   Android/iOS and desktop.
2. **Stateless vs Stateful?** — Stateless is immutable UI; Stateful holds mutable state
   (controllers, selected category, etc.).
3. **What is hot reload?** — Applies code changes live while preserving state.

## State management (Provider)
4. **Why Provider?** — Shared, observable state. `ChangeNotifier` + `Consumer`/`watch` rebuild
   only the widgets that listen.
5. **Which providers?** — AuthProvider (session), CartProvider (cart + totals),
   OrdersProvider (order history), ThemeProvider (dark mode).
6. **`context.read` vs `watch`?** — `watch` rebuilds on change; `read` fetches once.

## Forms & validation
7. **How is the form validated?** — `Form` + `GlobalKey<FormState>`; each `TextFormField` has a
   `validator`; `validate()` gates submission.
8. **Validations used?** — required fields, email regex, min password length, password match.

## Navigation
9. **How do you navigate?** — `Navigator.push` (product detail), `pushAndRemoveUntil` (login→home),
   and bottom `NavigationBar` tabs with `IndexedStack`.

## Local storage
10. **What is SharedPreferences?** — Key-value local store; keeps the logged-in user and order
    history across sessions. Demo account is seeded on first run.

## Products
11. **Where do products come from?** — `assets/json/products.json` (26 products), read with
    `rootBundle` and parsed into the `Product` model via `FutureBuilder`.
12. **Product fields?** — id, name, price, category, description, rating, stock, image, imageUrl,
    farmerName, location.

## Cart & Orders
13. **How does the cart work?** — CartProvider holds `CartItem`s; add/increment (capped at stock),
    decrement/remove; subtotal/total recomputed on every change.
14. **Checkout?** — Confirmation dialog → `OrdersProvider.placeOrder()` → order list persisted.

## Error handling
15. **How do you handle failures?** — Loading indicators, friendly error view with Retry for
    product loading, validation errors and SnackBars for auth issues.

## Git / team work
16. **How is the team organised?** — Five modules with clear owners (Auth, Home, Products,
    Cart & Orders, Profile & Integration); feature branches merged to `main` on GitHub.
17. **Commit style?** — Conventional commits: `feat(cart): add quantity controls`.

## Project-specific
18. **Why a marketplace?** — Reduce middlemen, improve price transparency, and give a simple
    mobile-first way to buy farm produce.
19. **Number of screens?** — Splash, Login, Register, Home, Search, Product Details, Cart,
    Orders, Profile (9 total).
20. **What would you add?** — Farmer dashboard, REST backend, payments, delivery tracking,
    multilingual support.
