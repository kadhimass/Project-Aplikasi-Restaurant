import 'package:equatable/equatable.dart';
import 'package:menu_makanan/model/produk.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Produk produk;

  const AddToCart(this.produk);

  @override
  List<Object> get props => [produk];
}

class RemoveFromCart extends CartEvent {
  final Produk produk;

  const RemoveFromCart(this.produk);

  @override
  List<Object> get props => [produk];
}

class ClearCart extends CartEvent {}

class UpdateQuantity extends CartEvent {
  final Produk produk;
  final int quantity;

  const UpdateQuantity(this.produk, this.quantity);

  @override
  List<Object> get props => [produk, quantity];
}
