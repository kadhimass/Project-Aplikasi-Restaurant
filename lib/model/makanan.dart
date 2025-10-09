import 'package:menu_makanan/model/produk.dart';

class Makanan extends Produk {
  final bool pedas;
  final String kategori;

  Makanan({
    required super.id,
    required super.nama,
    required super.deskripsi,
    required super.harga,
    required super.gambar,
    required super.rating,
    required super.linkWeb,
    required this.pedas,
    required this.kategori,
  });

  // Override method tampilkanInfo (polimorfisme)
  @override
  String tampilkanInfo() {
    String infoPedas = pedas ? "Pedas" : "Tidak Pedas";
    return "$nama ($infoPedas) - Rp${harga.toStringAsFixed(0)}";
  }
}
