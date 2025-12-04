import 'package:menu_makanan/features/product/domain/entities/product.dart';

class CartItem {
  final Produk produk;
  final int jumlah;

  const CartItem({required this.produk, this.jumlah = 1});

  double get totalHarga => produk.harga * jumlah;

  CartItem copyWith({Produk? produk, int? jumlah}) {
    return CartItem(
      produk: produk ?? this.produk,
      jumlah: jumlah ?? this.jumlah,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          produk == other.produk &&
          jumlah == other.jumlah;

  @override
  int get hashCode => produk.hashCode ^ jumlah.hashCode;
}
