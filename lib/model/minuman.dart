import 'package:menu_makanan/model/produk.dart';

class Minuman extends Produk {
  final bool dingin;
  final String ukuran;

  Minuman({
    required super.id,
    required super.nama,
    required super.deskripsi,
    required super.harga,
    required super.gambar,
    required super.rating,
    required super.linkWeb,
    required this.dingin,
    required this.ukuran,
  });

  // Override method tampilkanInfo (polimorfisme)
  @override
  String tampilkanInfo() {
    String infoSuhu = dingin ? "Dingin" : "Hangat";
    return "$nama ($infoSuhu, $ukuran) - Rp${harga.toStringAsFixed(0)}";
  }
}