# ShopGoes

A full-featured Flutter shopping app with 5 product categories, an attractive UI, and all essential e-commerce functionalities.  

---

## Features

- **Home Screen:** Browse featured products and deals.  
- **Best Deals:** Check latest offers and discounts.  
- **Cart:** View items, manage quantity, and proceed to checkout.  
- **Account:** User profile, login, and settings.  
- **AppBar:** Includes search, favorites, and notifications.  
- **Product Detail Page:**  
  - Multiple zoomable images  
  - Product details & availability  
  - Add to cart / favorites  
  - Related product suggestions  
- **Local Storage:** Uses Hive for storing cart and favorite items.  
- **Authentication:** Firebase Authentication for secure login and registration.  
- Fully functional, real-world shopping app experience.  

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  shared_preferences: ^2.5.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  get: ^4.7.2
  flutter_staggered_grid_view: ^0.6.2
  flutter_slidable: ^3.1.0
  image_picker: ^1.1.2
  carousel_slider: ^5.0.0
  photo_view: ^0.15.0
  google_sign_in: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
