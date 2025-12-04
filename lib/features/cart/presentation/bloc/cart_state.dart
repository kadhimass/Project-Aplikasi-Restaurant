import 'package:equatable/equatable.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart.dart';

class CartState extends Equatable {
  final Cart cart;

  const CartState({required this.cart});

  @override
  List<Object> get props => [cart];

  CartState copyWith({Cart? cart}) {
    return CartState(cart: cart ?? this.cart);
  }

  factory CartState.initial() {
    return const CartState(cart: Cart());
  }
}
