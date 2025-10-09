import 'package:menu_makanan/model/keranjang.dart';
// Import Produk

class Transaksi {
  final Keranjang keranjang;
  final String email;
  final String idTransaksi;
  final DateTime waktuTransaksi;

  const Transaksi({
    required this.keranjang,
    required this.email,
    required this.idTransaksi,
    required this.waktuTransaksi,
  });
}

