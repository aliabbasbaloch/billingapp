# 📱 Flutter Billing & POS App — Requirements Document

**Author:** Ali Abbas  
**Date:** March 2026  
**Platform:** Android  
**Language:** English  

---

## 🎯 Project Overview

A fully offline Android POS (Point of Sale) and billing application for small retail shops in Pakistan. The app enables product management via barcode scanning, smart cart checkout, PDF invoice generation, and payment detail configuration for Easypaisa and JazzCash.

---

## ✅ Core Features

### 1. Product / Inventory Management
- Add, edit, and delete products
- Each product stores:
  - **Name**
  - **Price** (PKR)
  - **Barcode / SKU** (for scanning)
- Product list with search functionality
- All data stored locally using **Hive** (NoSQL, offline)

---

### 2. Barcode Scanning
- Camera-based barcode/QR code scanning using `mobile_scanner`
- Scan a product barcode on the checkout screen to add it directly to cart
- If barcode not found → prompt to add new product
- Manual product search as fallback

---

### 3. Cart & Checkout
- Add/remove items from cart
- Adjust item quantity
- Auto-calculate:
  - Subtotal per item
  - Grand Total (PKR)
- Clear cart option
- Proceed to invoice generation from checkout screen

---

### 4. PDF Invoice Generation
- Generate a clean, professional PDF invoice containing:
  - **Shop name**
  - **Shop address**
  - **Invoice number** (auto-incremented)
  - **Date & Time**
  - **Itemized product list** (Name | Qty | Unit Price | Total)
  - **Grand Total (PKR)**
- PDF preview inside the app
- Options to:
  - **Share** via WhatsApp or other apps
  - **Save** to phone storage

---

### 5. Settings Page
The settings page will allow the shop owner to configure all app details:

#### 🏪 Shop Details
| Field | Description |
|---|---|
| Shop Name | Displayed on invoice header |
| Address Line 1 | e.g. Shop #5, Main Bazaar |
| Address Line 2 (optional) | e.g. Karachi, Sindh |
| Phone Number | Shop contact number |
| Receipt Footer Text | e.g. "Thank you, visit again!" |

#### 💳 Payment Details
Support for **both Easypaisa and JazzCash**:

| Field | Description |
|---|---|
| Payment Method | Easypaisa / JazzCash (toggle or both) |
| Account Title | Name on the account |
| Account Number | Mobile number linked to account |

> Payment details will appear at the bottom of the PDF invoice as an optional payment section.

---

## 🛠 Tech Stack

| Layer | Package |
|---|---|
| Framework | Flutter (Dart, SDK ≥ 3.1.0) |
| State Management | `flutter_bloc` |
| Local Database | `hive` + `hive_flutter` |
| Dependency Injection | `get_it` |
| Routing | `go_router` |
| Barcode Scanning | `mobile_scanner` |
| PDF Generation | `pdf` + `printing` |
| Code Generation | `hive_generator`, `build_runner` |
| Utilities | `equatable`, `fpdart`, `uuid` |

---

## 📁 Folder Structure

```
lib/
├── main.dart
├── config/
│   └── routes/
│       └── app_routes.dart
├── core/
│   ├── service_locator.dart
│   ├── data/
│   │   └── hive_database.dart
│   ├── error/
│   │   └── failure.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── usecase/
│   │   └── usecase.dart
│   ├── utils/
│   │   ├── app_validators.dart
│   │   ├── pdf_helper.dart
│   │   └── currency_formatter.dart
│   └── widgets/
│       ├── primary_button.dart
│       └── input_label.dart
└── features/
    ├── product/
    │   ├── data/
    │   │   ├── models/product_model.dart
    │   │   └── repositories/product_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/product.dart
    │   │   ├── repositories/product_repository.dart
    │   │   └── usecases/product_usecases.dart
    │   └── presentation/
    │       ├── bloc/
    │       └── pages/
    │           ├── product_list_page.dart
    │           ├── add_product_page.dart
    │           └── edit_product_page.dart
    ├── billing/
    │   ├── domain/
    │   │   └── entities/cart_item.dart
    │   └── presentation/
    │       ├── bloc/
    │       └── pages/
    │           ├── home_page.dart
    │           ├── scanner_page.dart
    │           └── checkout_page.dart
    ├── invoice/
    │   └── presentation/
    │       └── pages/
    │           └── invoice_preview_page.dart
    ├── settings/
    │   ├── data/
    │   │   ├── models/settings_model.dart
    │   │   └── repositories/settings_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/settings.dart
    │   │   └── repositories/settings_repository.dart
    │   └── presentation/
    │       ├── bloc/
    │       └── pages/
    │           └── settings_page.dart
    └── shop/
        ├── data/
        │   ├── models/shop_model.dart
        │   └── repositories/shop_repository_impl.dart
        ├── domain/
        │   ├── entities/shop.dart
        │   └── repositories/shop_repository.dart
        └── presentation/
            ├── bloc/
            └── pages/
                └── shop_details_page.dart
```

---

## 🗺 App Navigation Flow

```
App Start
    └── Home Page (Cart / Scanner)
        ├── Scan Barcode → Add to Cart
        ├── Browse Products → Add to Cart
        ├── Checkout Page
        │   └── Invoice Preview → Share / Save PDF
        └── Bottom Nav
            ├── Products (List / Add / Edit)
            └── Settings (Shop Details + Payment Info)
```

---

## 📦 pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  get_it: ^7.6.0
  go_router: ^12.0.0
  mobile_scanner: ^3.5.5
  pdf: ^3.10.7
  printing: ^5.11.0
  equatable: ^2.0.5
  fpdart: ^1.1.0
  uuid: ^4.2.1
  path_provider: ^2.1.1
  share_plus: ^7.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

---

## 🚀 Development Phases

### Phase 1 — Foundation
- [ ] Project setup with Clean Architecture structure
- [ ] Hive database initialization
- [ ] `get_it` service locator setup
- [ ] `go_router` navigation setup
- [ ] App theme configuration

### Phase 2 — Product Module
- [ ] Product Hive model + adapter
- [ ] Product repository (CRUD)
- [ ] Product BLoC (list, add, edit, delete)
- [ ] Product list page
- [ ] Add/Edit product pages

### Phase 3 — Billing Module
- [ ] Cart item entity
- [ ] Billing BLoC (add, remove, update qty, clear)
- [ ] Home page (cart view)
- [ ] Scanner page (barcode scan → cart)
- [ ] Checkout page (totals + proceed)

### Phase 4 — Invoice Module
- [ ] PDF layout design (shop header, item table, totals, payment info)
- [ ] Invoice number auto-increment
- [ ] PDF preview page
- [ ] Share via apps (WhatsApp etc.)
- [ ] Save to local storage

### Phase 5 — Settings Module
- [ ] Settings Hive model (shop details + payment details)
- [ ] Settings BLoC
- [ ] Settings page UI (shop fields + Easypaisa/JazzCash fields)
- [ ] Settings persisted and loaded on app start

---

## 📝 Notes

- All monetary values in **PKR (Pakistani Rupees)**
- Invoice numbers format: `INV-0001`, `INV-0002`, etc.
- Payment section on invoice is shown only if payment details are configured in settings
- App requires camera permission for barcode scanning (declared in `AndroidManifest.xml`)
- Storage permission required for saving PDFs on Android (handle Android 10+ scoped storage)
