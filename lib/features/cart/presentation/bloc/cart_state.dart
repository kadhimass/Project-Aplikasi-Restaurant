import 'package:menu_makanan/features/cart/domain/entities/cart.dart';

class CartState {
  final Cart cart;
  final bool isLoading;
  final String? error;

  const CartState({
    this.cart = const Cart(items: []),
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({Cart? cart, bool? isLoading, String? error}) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartState &&
          runtimeType == other.runtimeType &&
          cart == other.cart &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode => cart.hashCode ^ isLoading.hashCode ^ error.hashCode;
}
