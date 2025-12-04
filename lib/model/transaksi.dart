import 'package:menu_makanan/features/cart/domain/entities/cart.dart';

class Transaksi {
  final Cart keranjang;
  final String email;
  final String idTransaksi;
  final DateTime waktuTransaksi;

  Transaksi({
    required this.keranjang,
    required this.email,
    required this.idTransaksi,
    required this.waktuTransaksi,
  });
}
