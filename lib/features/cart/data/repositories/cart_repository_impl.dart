import 'package:menu_makanan/features/cart/data/models/cart_model.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
import 'package:menu_makanan/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl extends CartRepository {
  // In-memory storage for now (could be replaced with local storage)
  static CartModel _cartModel = const CartModel();

  @override
  Future<void> saveCart(Cart cart) async {
    _cartModel = CartModel.fromEntity(cart);
  }

  @override
  Future<Cart> loadCart() async {
    return _cartModel.toEntity();
  }

  @override
  Future<void> clearCart() async {
    _cartModel = const CartModel();
  }
}
