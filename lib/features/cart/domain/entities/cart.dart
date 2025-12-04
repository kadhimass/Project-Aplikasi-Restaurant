import 'package:menu_makanan/features/cart/domain/entities/cart_item.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';

class Cart {
  final List<CartItem> items;

  const Cart({this.items = const []});

  /// Get total number of items in cart
  int get totalItem => items.fold(0, (sum, item) => sum + item.jumlah);

  /// Get total price before discount
  double get totalHarga => items.fold(0, (sum, item) => sum + item.totalHarga);

  /// Check if eligible for discount (total > 100000)
  bool get dapatDiskon => totalHarga > 100000;

  /// Get discount amount if eligible
  double get jumlahDiskon => dapatDiskon ? 10000 : 0;

  /// Get price after discount
  double get hargaSetelahDiskon {
    final total = totalHarga - jumlahDiskon;
    return total < 0 ? 0 : total;
  }

  /// Add item to cart
  Cart addItem(Produk produk) {
    final existingItemIndex = items.indexWhere(
      (item) => item.produk.id == produk.id,
    );
    final updatedItems = List<CartItem>.from(items);

    if (existingItemIndex >= 0) {
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        jumlah: existingItem.jumlah + 1,
      );
    } else {
      updatedItems.add(CartItem(produk: produk, jumlah: 1));
    }

    return Cart(items: updatedItems);
  }

  /// Remove item from cart (completely)
  Cart removeItem(Produk produk) {
    final updatedItems = items
        .where((item) => item.produk.id != produk.id)
        .toList();
    return Cart(items: updatedItems);
  }

  /// Decrease item quantity
  Cart decreaseQuantity(Produk produk) {
    final existingItemIndex = items.indexWhere(
      (item) => item.produk.id == produk.id,
    );
    final updatedItems = List<CartItem>.from(items);

    if (existingItemIndex >= 0) {
      final existingItem = updatedItems[existingItemIndex];
      if (existingItem.jumlah > 1) {
        updatedItems[existingItemIndex] = existingItem.copyWith(
          jumlah: existingItem.jumlah - 1,
        );
      } else {
        updatedItems.removeAt(existingItemIndex);
      }
    }

    return Cart(items: updatedItems);
  }

  /// Update item quantity
  Cart updateQuantity(Produk produk, int quantity) {
    if (quantity <= 0) {
      return removeItem(produk);
    }

    final existingItemIndex = items.indexWhere(
      (item) => item.produk.id == produk.id,
    );
    final updatedItems = List<CartItem>.from(items);

    if (existingItemIndex >= 0) {
      updatedItems[existingItemIndex] = CartItem(
        produk: produk,
        jumlah: quantity,
      );
    } else {
      updatedItems.add(CartItem(produk: produk, jumlah: quantity));
    }

    return Cart(items: updatedItems);
  }

  /// Clear all items from cart
  Cart clear() => const Cart(items: []);

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cart && runtimeType == other.runtimeType && items == other.items;

  @override
  int get hashCode => items.hashCode;
}
