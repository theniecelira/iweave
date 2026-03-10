# iWeave Flutter App

> **"Crafting Unforgettable Experiences, One Tikog at A Time!"**
>
> A digital platform connecting tourists and buyers with the master weavers of Basey, Samar, Philippines.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0

### Run the App

```bash
flutter pub get
flutter run
```

### Demo Accounts

| Role    | Email                  | Password   |
|---------|------------------------|------------|
| Tourist | tourist@iweave.ph      | tourist123 |
| Weaver  | weaver@iweave.ph       | weaver123  |
| Admin   | admin@iweave.ph        | admin123   |
| Demo    | demo@demo.com          | demo123    |

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| Splash | Animated logo, provider initialization |
| Onboarding | 3-page intro carousel |
| Login / Sign Up | Form validation, auth flow |
| Home | Banner, featured products, tours, weavers |
| Products | Search + category filter grid |
| Product Detail | Image carousel, customization, cart |
| Book Tour | Packages, Hotels, Restaurants tabs |
| Tour Detail | Date picker, guest count, booking |
| Cart | Quantity controls, checkout |
| Bookings | User bookings with cancel option |
| Notifications | Read/unread states, type icons |
| Weavers | Weaver stories and profiles |
| Profile | Edit profile, settings, logout |

---

## 🏗️ Architecture

```
lib/
├── main.dart                  # Entry point
├── app/
│   └── app_router.dart        # Named route navigation
├── core/
│   ├── constants/             # Colors, dimensions
│   └── utils/                 # Formatters, validators
├── theme/
│   └── app_theme.dart         # Material 3 theme (Poppins font)
├── models/                    # Data models
├── data/
│   └── mock_data.dart         # Mock products, tours, weavers
├── services/
│   └── auth_service.dart      # Mock auth service
├── providers/                 # ChangeNotifier state management
├── widgets/                   # Reusable UI components
└── screens/                   # Feature screens
```

**State Management:** Provider (ChangeNotifier)  
**Theme:** Material 3 · Burgundy `#7D1935` · Orange `#E8732A` · Warm cream `#F5F0EB`  
**Font:** Poppins

---

## 🛒 Mock Data

- **10 Products:** Banig bags, mats, accessories, tech cases
- **5 Tour Packages:** Saob Cave, Sohoton, Church Tour, Weekend Escape, Custom Tour
- **3 Weavers:** Nanay Rosario, Aling Perla, Manang Luz
- **4 Accommodations** and **4 Restaurants** in Basey, Samar

---

## 📦 Dependencies

```yaml
provider: ^6.1.2        # State management
shared_preferences: ^2.2.3  # Local persistence
intl: ^0.19.0           # Date/currency formatting
```

---

*Built by Team Weannov8 · UP Tacloban College · 2024*
