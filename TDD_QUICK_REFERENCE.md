# TDD + Clean Architecture Quick Reference

## Project Structure
```
lib/
├── core/                          # Core utilities
│   ├── usecase.dart              # Base UseCase class
│   └── errors/failures.dart      # Failure error handling
├── features/produk/              # Feature module
│   ├── domain/                   # Business logic (entities, repos, usecases)
│   ├── data/                     # Data sources & repositories
│   └── presentation/             # BLoC + UI pages
├── services/                     # ⭐ NEW: Reusable business logic
│   ├── produk_filter_service.dart
│   └── cart_service.dart
└── pages/                        # UI pages (refactored to use services)
    ├── halaman_beranda.dart      # ✅ Uses ProdukFilterService
    ├── halaman_keranjang.dart    # ✅ Uses CartService
    └── halaman_detailproduk.dart # ✅ Already clean

test/
├── utils/mocks.dart              # Central mock registry
├── features/produk/
│   ├── domain/usecases/          # Domain tests (3)
│   └── presentation/bloc/        # BLoC tests (4)
└── services/                     # Service tests (28)
    ├── produk_filter_service_test.dart
    └── cart_service_test.dart
```

## Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/cart_service_test.dart

# Run with coverage
flutter test --coverage

# Run specific test group
flutter test -k "CartService"
```

## Key Files Modified/Created

### Created
- `lib/services/produk_filter_service.dart` - 4 static methods for filtering/sorting
- `lib/services/cart_service.dart` - 7 static methods for cart operations
- `test/services/produk_filter_service_test.dart` - 10 unit tests
- `test/services/cart_service_test.dart` - 18 unit tests
- `CLEAN_ARCHITECTURE_TDD_SUMMARY.md` - Full documentation

### Modified
- `lib/pages/halaman_beranda.dart` - Added ProdukFilterService import, simplified filter method
- `lib/pages/halaman_keranjang.dart` - Added CartService import, simplified checkout logic
- `pubspec.yaml` - Added test dependencies (mocktail, bloc_test)

### Test Coverage
- **Total Tests:** 35
- **Services:** 28 tests (100% business logic coverage)
- **Domain:** 3 usecase tests
- **Presentation:** 4 BLoC tests
- **Status:** ✅ All passing

## Quick Start: Adding New Feature

1. **Create domain layer** (entities, repositories, usecases)
   ```dart
   // lib/features/my_feature/domain/entities/
   class MyEntity { ... }
   
   // lib/features/my_feature/domain/repositories/
   abstract class MyRepository { ... }
   
   // lib/features/my_feature/domain/usecases/
   class MyUseCase extends UseCase<Output, Input> { ... }
   ```

2. **Test domain layer**
   ```dart
   // test/features/my_feature/domain/usecases/my_usecase_test.dart
   test('does something', () { ... });
   ```

3. **Create data layer** (datasources, models, repository impl)
   ```dart
   // lib/features/my_feature/data/
   class MyDataSource { ... }
   class MyModel { ... }
   class MyRepositoryImpl extends MyRepository { ... }
   ```

4. **Create presentation layer** (BLoC, pages)
   ```dart
   // lib/features/my_feature/presentation/
   class MyBloc extends Bloc { ... }
   class MyPage extends StatelessWidget { ... }
   ```

5. **Add integration test**
   ```dart
   // test/features/my_feature/
   test('integration test', () { ... });
   ```

## Service Layer Benefits

✅ **Testability:** Pure functions = easy to test  
✅ **Reusability:** Use from BLoC, pages, or other services  
✅ **Maintainability:** Single source of truth for business logic  
✅ **Readability:** Self-documenting static methods  
✅ **Performance:** No unnecessary object creation  

## Example: Using ProdukFilterService

```dart
// In page or BLoC
final filtered = ProdukFilterService.filterAndSort(
  produkList,
  'makanan',      // filterType
  'nasi',         // searchQuery
  'harga_asc'     // sortOption
);
```

## Example: Using CartService

```dart
// Get cart summary for UI
final summary = CartService.getCartSummary(keranjang);
print('Total: ${summary.getFormattedFinalPrice()}');
print('Discount: ${summary.discount > 0}');

// Create transaction for checkout
final transaction = CartService.createTransaction(
  keranjang: keranjang,
  email: userEmail,
);
```

## Common Testing Patterns

### Test Service Method
```dart
test('method does X', () {
  // Arrange
  final input = testData;
  
  // Act
  final result = CartService.calculateSubtotal(input);
  
  // Assert
  expect(result, expectedValue);
});
```

### Test BLoC Event
```dart
blocTest<CartBloc, CartState>(
  'emits [ProdukLoading, ProdukLoaded] when GetAllProdukEvent is added',
  build: () => CartBloc(mockRepository),
  act: (bloc) => bloc.add(GetAllProdukEvent()),
  expect: () => [
    CartLoading(),
    CartLoaded(products),
  ],
);
```

### Mock Repository
```dart
// In test
final mockRepo = MockProdukRepository();

// Use in test
when(() => mockRepo.getAllProduk())
  .thenAnswer((_) async => Right(products));
```

## Troubleshooting

### Tests not running
- Run `flutter pub get`
- Check test file import paths
- Verify test function is top-level, not nested

### Import errors
- Use absolute imports: `import 'package:menu_makanan/...'`
- Check pubspec.yaml for correct package name

### Mock not working
- Use `MockClassName extends Mock implements RealClassName`
- Set up expectations before act: `when(...).thenAnswer(...)`
- Import mock from `test/utils/mocks.dart`

---

**Last Updated:** 2025  
**Test Status:** ✅ 35/35 Passing
