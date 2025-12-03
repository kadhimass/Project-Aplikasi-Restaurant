# Clean Architecture + TDD Implementation Summary

## Overview
This document summarizes the Clean Architecture and Test-Driven Development (TDD) implementation for the Restaurant App (Flutter). The refactoring focused on extracting business logic from presentation layer into reusable service layer components with comprehensive unit test coverage.

---

## 1. TDD Infrastructure Setup

### Dependencies Added
```yaml
dev_dependencies:
  test: any
  mocktail: ^1.0.4
  bloc_test: ^9.1.0
```

### Core Helpers Created

#### `lib/core/usecase.dart`
- Generic `UseCase<Type, Params>` base class for standardizing domain layer use cases
- `NoParams` helper class for use cases without parameters
- **Pattern:** Template method pattern for consistent use case structure

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
```

#### `lib/core/errors/failures.dart`
- `Failure` class for consistent domain layer error representation
- Ensures separation of concerns between layers
- Enables proper error handling in BLoC/presentation

---

## 2. Test Infrastructure

### Central Mock Registry
**Location:** `test/utils/mocks.dart`
- Centralizes mock definitions for reuse across test suites
- Reduces boilerplate and ensures consistency
- Example: `MockProdukRepository` used in both domain and BLoC tests

### Test Patterns Applied

#### Unit Tests (Domain + Service)
- **UseCase tests:** Test business logic in isolation
  - `test/features/produk/domain/usecases/get_all_produk_usecase_test.dart`
  - `test/features/produk/domain/usecases/search_produk_usecase_test.dart`
- **Service tests:** Test stateless utility functions
  - `test/services/produk_filter_service_test.dart` (10 tests)
  - `test/services/cart_service_test.dart` (18 tests)

#### BLoC Tests
- **Framework:** `bloc_test` library
- **Coverage:** State transitions, event handling, error cases
- **File:** `test/features/produk/presentation/bloc/produk_bloc_test.dart` (4 tests)

---

## 3. Service Layer Extraction Pattern

### Pattern: Business Logic → Service Layer

Services are stateless utility classes that encapsulate business logic, enabling:
- **Reusability:** Same logic can be used from BLoC, UI, or other services
- **Testability:** Pure functions are easy to test independently
- **Maintainability:** Logic changes in one place affect all consumers

---

## 4. Page-by-Page Refactoring

### 4.1 halaman_beranda.dart (Home Page)

#### Original Challenge
- ~40 lines of filter/sort logic embedded in `_HalamanBerandaState`
- Mixed UI and business logic
- Difficult to test UI without complex mocking

#### Solution
**Extract to `ProdukFilterService`**

```dart
// Service provides static methods
class ProdukFilterService {
  static List<Produk> filterByType(List<Produk> produkList, String filterType) {...}
  static List<Produk> filterBySearch(List<Produk> produkList, String query) {...}
  static List<Produk> sortProducts(List<Produk> produkList, String sortOption) {...}
  static List<Produk> filterAndSort(...) {...}
}
```

#### Page Refactor
```dart
// Before: ~40 lines of logic in _getFilteredAndSortedProducts()
// After: Single service call
List<Produk> _getFilteredAndSortedProducts(List<Produk> produkList) {
  return ProdukFilterService.filterAndSort(
    produkList, _filterType, _searchQuery, _sortOption,
  );
}
```

#### Test Coverage
- **File:** `test/services/produk_filter_service_test.dart`
- **Tests:** 10 unit tests covering:
  - filterByType (makanan/minuman/semua)
  - filterBySearch (case-insensitive matching)
  - sortProducts (by name/price/rating)
  - filterAndSort (combined operations)
- **Result:** ✅ 10/10 passing

### 4.2 halaman_keranjang.dart (Cart Page)

#### Original Challenge
- 740 lines of code
- Complex checkout logic mixed with UI
- Transaction ID generation, discount calculation, payment dialog all embedded

#### Solution
**Extract to `CartService`**

```dart
class CartService {
  // Calculations
  static double calculateSubtotal(Keranjang keranjang)
  static bool isEligibleForDiscount(double subtotal)
  static double calculateDiscount(double subtotal)
  static double calculateFinalPrice(double subtotal)
  
  // Utilities
  static String generateTransactionId()
  static String formatCurrency(double amount)
  static CartSummary getCartSummary(Keranjang keranjang)
  
  // Factory
  static Transaksi createTransaction({...})
}
```

#### Page Refactor
```dart
// Before: Multi-line manual transaction creation
void _prosesCheckout() {
  final keranjangSebelumCheckout = Keranjang(
    initialItems: cartState.keranjang.items.map(...).toList(),
  );
  final idTransaksi = 'WRKT${DateTime.now().millisecondsSinceEpoch}';
  final waktuTransaksi = DateTime.now();
  final newTransaction = Transaksi(...);
  ...
}

// After: Single service call
void _prosesCheckout() {
  final newTransaction = CartService.createTransaction(
    keranjang: cartState.keranjang,
    email: widget.email,
  );
  // Rest of navigation logic...
}
```

#### Test Coverage
- **File:** `test/services/cart_service_test.dart`
- **Tests:** 18 unit tests covering:
  - Subtotal calculation (empty cart, single/multiple items)
  - Discount eligibility (below/at/above threshold)
  - Discount amount (0 or fixed 10k)
  - Final price (with/without discount)
  - Transaction ID generation (uniqueness)
  - Currency formatting (Rupiah)
  - Cart summary (aggregated data)
  - Transaction creation (complete object)
- **Result:** ✅ 18/18 passing

### 4.3 halaman_detailproduk.dart (Product Detail Page)

#### Assessment
- **Size:** 275 lines (lean)
- **Logic:** Primarily presentation (display product details, ratings, categories)
- **Actions:** Single add-to-cart action that correctly delegates to BLoC

#### Decision: No Refactoring Required
- Page already follows clean separation of concerns
- Business logic appropriately handled by BLoC
- UI code is isolated and testable as-is

---

## 5. Architecture Layers

### Domain Layer (Business Logic)
```
lib/features/produk/domain/
├── entities/
│   └── produk_entity.dart           # Pure data model
├── repositories/
│   └── produk_repository.dart       # Abstract repository contract
└── usecases/
    ├── get_all_produk_usecase.dart
    └── search_produk_usecase.dart
```

### Data Layer (External Resources)
```
lib/features/produk/data/
├── datasources/
│   ├── produk_datasource.dart       # Abstract data contract
│   └── produk_local_datasource.dart # In-memory implementation
├── models/
│   └── produk_model.dart            # DTO with serialization
└── repositories/
    └── produk_repository_impl.dart  # Repository implementation
```

### Presentation Layer (UI + State Management)
```
lib/pages/
├── halaman_beranda.dart             # ✅ Refactored (uses ProdukFilterService)
├── halaman_keranjang.dart           # ✅ Refactored (uses CartService)
└── halaman_detailproduk.dart        # ✅ Already clean (no changes needed)

lib/bloc/
├── produk_bloc.dart                 # Produk state management
└── cart_bloc.dart                   # Cart state management

lib/services/                         # ⭐ NEW: Reusable business logic
├── produk_filter_service.dart       # Filter/sort operations
└── cart_service.dart                # Cart calculations & transactions
```

---

## 6. Test Metrics

### Total Test Coverage
| Layer | Component | Tests | Status |
|-------|-----------|-------|--------|
| Domain | GetAllProdukUseCase | 1 | ✅ Pass |
| Domain | SearchProdukUseCase | 2 | ✅ Pass |
| Domain | Total | 3 | ✅ 3/3 |
| Presentation | ProdukBloc | 4 | ✅ Pass |
| Service | ProdukFilterService | 10 | ✅ Pass |
| Service | CartService | 18 | ✅ Pass |
| Service | Total | 28 | ✅ 28/28 |
| **Grand Total** | | **35** | **✅ 35/35** |

### Test Execution
```bash
# Run all service tests
flutter test test/services/

# Run all domain tests
flutter test test/features/produk/domain/

# Run all BLoC tests
flutter test test/features/produk/presentation/bloc/

# Run everything
flutter test
```

---

## 7. Code Quality Improvements

### Before Refactoring
- ❌ Business logic scattered across pages
- ❌ Difficult to test without UI mocking
- ❌ Code duplication (filter/sort logic, currency formatting)
- ❌ Large methods mixing concerns (checkout ~50 lines)

### After Refactoring
- ✅ Pure functions in service layer (easily testable)
- ✅ Unit test coverage for all business logic
- ✅ Reusable services (used from BLoC, pages, or other services)
- ✅ Clean separation of concerns
- ✅ Easier to maintain and extend

### Code Reduction
- **halaman_beranda:** Reduced `_getFilteredAndSortedProducts()` from ~40 to ~7 lines
- **halaman_keranjang:** Reduced `_prosesCheckout()` from ~50 to ~20 lines
- **Overall:** ~80 lines of duplicated logic eliminated through services

---

## 8. Testing Best Practices Applied

### 1. Arrange-Act-Assert (AAA) Pattern
```dart
test('example', () {
  // Arrange
  final input = testData;
  
  // Act
  final result = service.method(input);
  
  // Assert
  expect(result, expectedValue);
});
```

### 2. Descriptive Test Names
- `calculateSubtotal_returns0_forEmptyCart`
- `isEligibleForDiscount_returnsFalse_ifSubtotalBelowThreshold`
- `formatCurrency_formatsLargeAmounts_correctly`

### 3. Single Responsibility Per Test
- Each test verifies one behavior
- Easy to identify what failed when test breaks

### 4. Mocking with Mocktail
- Central `MockProdukRepository` in `test/utils/mocks.dart`
- Used consistently across domain and BLoC tests

---

## 9. Design Patterns Used

| Pattern | Location | Purpose |
|---------|----------|---------|
| Repository | `lib/features/produk/data/repositories/` | Data abstraction |
| UseCase | `lib/features/produk/domain/usecases/` | Domain logic encapsulation |
| Service | `lib/services/` | Reusable business logic |
| Factory | `CartService.createTransaction()` | Object creation |
| BLoC | `lib/bloc/` | State management |
| Builder | UI pages | Widget composition |

---

## 10. TDD Workflow Applied

1. **Write failing test** → Red
   ```dart
   test('filters by type correctly', () {
     expect(result, expectedValue); // Test fails
   });
   ```

2. **Write minimal implementation** → Green
   ```dart
   static List<Produk> filterByType(...) {
     // Minimal implementation to pass test
   }
   ```

3. **Refactor for quality** → Green (refactored)
   ```dart
   static List<Produk> filterByType(...) {
     // Optimized, readable implementation
   }
   ```

---

## 11. Future Improvements

### Short Term
- [ ] Add integration tests for service layer + BLoC
- [ ] Add error handling tests (exceptions, edge cases)
- [ ] Document API contracts in service classes

### Medium Term
- [ ] Create more domain use cases (checkout, rating, recommendations)
- [ ] Add repository layer tests (mocking data sources)
- [ ] Implement caching service

### Long Term
- [ ] Migrate to Riverpod for state management
- [ ] Implement GetIt for dependency injection
- [ ] Add performance monitoring
- [ ] Expand to other features (settings, reviews, etc.)

---

## 12. Conclusion

The refactoring successfully established:
1. ✅ **Clean Architecture:** 3-layer separation (Domain/Data/Presentation)
2. ✅ **TDD Practices:** 35 unit tests with comprehensive coverage
3. ✅ **Service Layer:** Reusable business logic extracted from UI
4. ✅ **Code Quality:** Improved maintainability and testability
5. ✅ **Best Practices:** Mocktail, BLoC pattern, AAA testing

The foundation is now in place for sustainable, scalable development of the Restaurant App.

---

**Author:** GitHub Copilot  
**Date:** 2025  
**Status:** Complete ✅
