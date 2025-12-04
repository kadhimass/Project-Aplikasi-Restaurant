import 'package:menu_makanan/features/product/domain/entities/product.dart';

/// Abstract Data Source interface untuk Produk
/// Mendefinisikan contract untuk data sources (local, remote, etc)
abstract class ProdukDataSource {
  /// Fetch semua produk
  Future<List<Produk>> getAllProduk();

  /// Fetch produk berdasarkan ID
  Future<Produk> getProdukById(String id);

  /// Search produk berdasarkan query
  Future<List<Produk>> searchProduk(String query);
}
