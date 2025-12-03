# 🔍 Quick Reference: New Architecture

## File Locations Quick Map

### If you need Cart logic:
```
lib/features/cart/
├── domain/entities/cart.dart            ← Cart data structure
├── domain/repositories/                 ← Data access interface  
├── data/repositories/cart_repository_impl.dart  ← Actually loads/saves
├── presentation/bloc/cart_bloc.dart     ← State management
└── presentation/pages/cart_page.dart    ← UI (keranjang screen)
```

### Cart Feature Usage Example:
```dart
// In a page/widget
@override
Widget build(BuildContext context) {
  return BlocBuilder<CartBloc, CartState>(
    builder: (context, state) {
      // state.cart is the Cart entity from domain/entities/cart.dart
      return Text('Items: ${state.cart.totalItem}');
    },
  );
}

// Add to cart
context.read<CartBloc>().add(AddToCart(produk));
```

## Import Cheat Sheet

### ❌ Old Imports (Don't Use)
```dart
import 'package:menu_makanan/bloc/cart_bloc.dart';
import 'package:menu_makanan/pages/halaman_keranjang.dart';
import 'package:menu_makanan/model/keranjang.dart';
```

### ✅ New Imports (Use These)
```dart
// For BLoC
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_state.dart';

// For Pages
import 'package:menu_makanan/features/cart/presentation/pages/cart_page.dart';

// For Domain Entities (if needed)
import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart_item.dart';
```

## Common Tasks

### Task: Display Cart Total
```dart
BlocBuilder<CartBloc, CartState>(
  builder: (context, state) {
    return Text(state.cart.totalHarga.toString());  // state.cart is Cart entity
  },
);
```

### Task: Add Item to Cart
```dart
ElevatedButton(
  onPressed: () {
    context.read<CartBloc>().add(AddToCart(produk));
  },
  child: Text('Add to Cart'),
)
```

### Task: Update Cart Quantity
```dart
context.read<CartBloc>().add(UpdateQuantity(produk, 5));
```

### Task: Access Cart Items
```dart
final items = state.cart.items;  // List<CartItem>
for (var item in items) {
  print(item.produk.nama);  // Access product
  print(item.jumlah);       // Access quantity
}
```

## File Structure Visualization

```
Cart Feature (Complete Example)
│
├─ DOMAIN (Pure Dart - No Flutter)
│  └─ entities/cart.dart
│     └─ class Cart {
│        - List<CartItem> items
│        - int totalItem
│        - double totalHarga
│        - Cart addItem(Produk) → new Cart
│        - Cart removeItem(Produk) → new Cart
│     }
│
├─ DATA (Persistence)
│  ├─ models/cart_model.dart
│  │  └─ class CartModel {
│  │     - toJson() for storage
│  │     - fromJson() for loading
│  │  }
│  └─ repositories/cart_repository_impl.dart
│     └─ class CartRepositoryImpl {
│        - saveCart(Cart)
│        - loadCart() → Cart
│     }
│
└─ PRESENTATION (UI)
   ├─ bloc/cart_bloc.dart
   │  └─ class CartBloc {
   │     - handles AddToCart, RemoveFromCart events
   │     - emits CartState
   │  }
   └─ pages/cart_page.dart
      └─ class CartPage {
         - BlocBuilder reads CartState
         - Buttons dispatch events
      }
```

## Dependency Flow (Correct Direction)

```
UI (presentation/)
  ↓ uses
BLoC (presentation/bloc/)
  ↓ uses
Entities & Repository Interface (domain/)
  ↓ implemented by
Repository Impl (data/)
  ↓ uses
Models & Storage (data/models/)

✅ Clean: Can test domain without UI
✅ Safe: Can swap data implementations
❌ NEVER: Let data depend on presentation
```

## Testing Pattern

```dart
// Test domain entity (no mocks needed)
test('cart calculates total correctly', () {
  final cart = Cart(items: [...]);
  expect(cart.totalHarga, 500000);
});

// Test usecase (mock repository)
test('load cart returns saved cart', () async {
  final mockRepo = MockCartRepository();
  final usecase = LoadCartUsecase(mockRepo);
  final result = await usecase(NoParams());
  expect(result.items.length, 2);
});

// Test BLoC (mock repository)
blocTest(
  'AddToCart emits new state with updated cart',
  build: () => CartBloc(repository: MockRepository()),
  act: (bloc) => bloc.add(AddToCart(produk)),
  expect: () => [
    isA<CartState>().having((s) => s.cart.items.length, 'length', 1),
  ],
);
```

## Common Errors & Fixes

### Error: "The named parameter 'cartRepository' is required"
**Cause:** Using old CartBloc() without repository
**Fix:** 
```dart
// ❌ Old
CartBloc()

// ✅ New  
CartBloc(cartRepository: CartRepositoryImpl())
```

### Error: "Import 'package:menu_makanan/bloc/cart_bloc.dart' not found"
**Cause:** Using old import path
**Fix:**
```dart
// ❌ Old
import 'package:menu_makanan/bloc/cart_bloc.dart';

// ✅ New
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
```

### Error: "Undefined name 'Keranjang'"
**Cause:** Trying to use old model instead of Cart entity
**Fix:**
```dart
// ❌ Old
Keranjang keranjang = ...;

// ✅ New
Cart cart = state.cart;  // From CartState in BLoC
```

## Next Steps for Developer

1. Search codebase for old imports:
   - `lib/bloc/cart_bloc.dart` → update to new path
   - `lib/pages/halaman_keranjang.dart` → update to CartPage
   - `lib/model/keranjang.dart` → use Cart entity

2. Run build and fix any import errors:
   ```bash
   flutter pub get
   flutter clean && flutter pub get
   ```

3. Test cart functionality works with new structure

4. Apply same pattern to other features (transaksi, auth, etc)

---

**Remember:** This structure makes code easier to find, test, and modify!
