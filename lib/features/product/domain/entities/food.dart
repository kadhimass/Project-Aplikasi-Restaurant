import 'package:menu_makanan/features/product/domain/entities/product.dart';

class Makanan extends Produk {
  const Makanan({
    required super.id,
    required super.nama,
    required super.deskripsi,
    required super.harga,
    required super.gambar,
    required super.rating,
    super.linkWeb = '',
    super.bahan,
  });

  @override
  String get kategori => 'Makanan';
}
