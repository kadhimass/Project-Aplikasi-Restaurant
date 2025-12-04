import 'package:menu_makanan/features/product/data/datasources/dummydata.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';


abstract class ProdukLocalDataSource {
  Future<List<Produk>> getAllProduk();
  Future<Produk> getProdukById(String id);
  Future<List<Produk>> searchProduk(String query);
}

class ProdukLocalDataSourceImpl implements ProdukLocalDataSource {
  @override
  Future<List<Produk>> getAllProduk() async {
    // Simulasi delay dari database local
    await Future.delayed(const Duration(milliseconds: 500));

    // Konversi dari model lokal ke domain entity
    final produkList = DummyData.getProdukList();
    return produkList.map((produk) {
      return Produk(
        id: produk.id,
        nama: produk.nama,
        deskripsi: produk.deskripsi,
        harga: produk.harga,
        gambar: produk.gambar,
        rating: produk.rating,
        linkWeb: produk.linkWeb,
      );
    }).toList();
    // Return empty list - data harus dari API
    return [];
  }

  @override
  Future<Produk> getProdukById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final produkList = DummyData.getProdukList();
    final produk = produkList.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Produk not found'),
    );

    return Produk(
      id: produk.id,
      nama: produk.nama,
      deskripsi: produk.deskripsi,
      harga: produk.harga,
      gambar: produk.gambar,
      rating: produk.rating,
      linkWeb: produk.linkWeb,
    );
    // Data harus dari API
    throw Exception('Produk not found - use API data source');
  }

  @override
  Future<List<Produk>> searchProduk(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final produkList = DummyData.getProdukList();
    final result = produkList
        .where(
          (produk) =>
              produk.nama.toLowerCase().contains(query.toLowerCase()) ||
              produk.deskripsi.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return result.map((produk) {
      return Produk(
        id: produk.id,
        nama: produk.nama,
        deskripsi: produk.deskripsi,
        harga: produk.harga,
        gambar: produk.gambar,
        rating: produk.rating,
        linkWeb: produk.linkWeb,
      );
    }).toList();
    // Data harus dari API
    return [];
  }
}
