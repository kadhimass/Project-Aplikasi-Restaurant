import 'package:equatable/equatable.dart';
import 'package:menu_makanan/model/keranjang.dart';

class CartState extends Equatable {
  final Keranjang keranjang;

  const CartState({required this.keranjang});

  @override
  List<Object> get props => [keranjang];

  CartState copyWith({Keranjang? keranjang}) {
    return CartState(keranjang: keranjang ?? this.keranjang);
  }

  factory CartState.initial() {
    return CartState(keranjang: Keranjang());
  }
}
