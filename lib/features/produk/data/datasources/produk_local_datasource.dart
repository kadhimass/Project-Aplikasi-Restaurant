import 'package:menu_makanan/features/produk/data/datasources/produk_datasource.dart';
import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';

/// Local Data Source: Implementasi dari datasource menggunakan dummy data
/// Bisa di-extend untuk menggunakan local database (SQLite, Hive, etc)
class ProdukLocalDataSource extends ProdukDataSource {
  @override
  Future<List<ProdukEntity>> getAllProduk() async {
    // Simulasi delay dari database local
    await Future.delayed(const Duration(milliseconds: 500));

    // Return empty list - data harus dari API
    return [];
  }

  @override
  Future<ProdukEntity> getProdukById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Data harus dari API
    throw Exception('Produk not found - use API data source');
  }

  @override
  Future<List<ProdukEntity>> searchProduk(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Data harus dari API
    return [];
  }
}
