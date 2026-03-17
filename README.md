# Logiks Solutions - Flutter Assignment

This is a Flutter app built as part of a technical assignment.
The goal was to implement authentication (including biometrics) and a dynamic product list with real-time updates.

---

## 🔐 Authentication

There are two ways to log in:

**Manual login**

* username: `test`
* password: `test123`

**Biometric login**

* Uses Face ID / Fingerprint depending on the device
* On Android, if biometrics is not available, it falls back to PIN/Pattern

---

## 📦 Products

After login, the app loads products from:
https://restful-api.dev/

What’s implemented:

* Product list (id + name)
* Accordion-style expansion for details
* Only one item can be expanded at a time
* Auto-scroll when expanding (so content is fully visible)

---

## ⚡ Real-time updates

One product simulates live updates using a timer.

* Values change every few seconds
* If the item is open → it highlights changes
* If closed → shows a small indicator

---

## 🧠 Tech stack

* Flutter
* Riverpod (state management)
* Dio (API)
* local_auth (biometrics)

---

## 🏗️ Structure

I used a simple Clean Architecture approach:

* `core/` → shared logic (network, errors)
* `features/`

  * `auth/`
  * `products/`
* Each feature has:

  * data
  * domain
  * presentation

---

## 🧪 Tests

Basic unit tests are included for:

* authentication logic
* API layer

Run with:

```
flutter test
```

---

## 📱 APK

You can build the APK with:

```
flutter build apk 
```
