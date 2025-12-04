import 'package:equatable/equatable.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';

/// Base class untuk semua cart events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk menambah produk ke keranjang
class AddToCart extends CartEvent {
  final Produk produk;

  const AddToCart(this.produk);

  @override
  List<Object> get props => [produk];
}

/// Event untuk menghapus produk dari keranjang
class RemoveFromCart extends CartEvent {
  final Produk produk;

  const RemoveFromCart(this.produk);

  @override
  List<Object> get props => [produk];
}

/// Event untuk mengosongkan seluruh keranjang
class ClearCart extends CartEvent {}

/// Event untuk mengupdate jumlah produk
class UpdateQuantity extends CartEvent {
  final Produk produk;
  final int quantity;

  const UpdateQuantity(this.produk, this.quantity);

  @override
  List<Object> get props => [produk, quantity];
}

/// Event untuk mengurangi jumlah produk
class DecreaseQuantity extends CartEvent {
  final Produk produk;

  const DecreaseQuantity(this.produk);

  @override
  List<Object> get props => [produk];
}

/// Event untuk menambah jumlah produk
class IncreaseQuantity extends CartEvent {
  final Produk produk;

  const IncreaseQuantity(this.produk);

  @override
  List<Object> get props => [produk];
}
