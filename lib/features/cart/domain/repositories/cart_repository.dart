import 'package:menu_makanan/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  Future<void> saveCart(Cart cart);
  Future<Cart> loadCart();
  Future<void> clearCart();
}
