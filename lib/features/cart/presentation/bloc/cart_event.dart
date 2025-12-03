import 'package:menu_makanan/model/produk.dart';

abstract class CartEvent {
  const CartEvent();
}

class AddToCart extends CartEvent {
  final Produk produk;
  const AddToCart(this.produk);
}

class RemoveFromCart extends CartEvent {
  final Produk produk;
  const RemoveFromCart(this.produk);
}

class DecreaseQuantity extends CartEvent {
  final Produk produk;
  const DecreaseQuantity(this.produk);
}

class UpdateQuantity extends CartEvent {
  final Produk produk;
  final int quantity;
  const UpdateQuantity(this.produk, this.quantity);
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class LoadCart extends CartEvent {
  const LoadCart();
}
