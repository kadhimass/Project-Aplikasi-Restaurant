import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
// Import Produk

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

  // Getter untuk informasi diskon
  double get totalSebelumDiskon => keranjang.totalHarga;
  double get jumlahDiskon => keranjang.jumlahDiskon;
  double get totalSetelahDiskon => keranjang.hargaSetelahDiskon;
  bool get dapatDiskon => keranjang.dapatDiskon;
}