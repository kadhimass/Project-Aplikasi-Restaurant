import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';

/// Abstract Repository Interface untuk Produk
/// Mendefinisikan contract yang harus diimplementasikan oleh repository konkret
abstract class ProdukRepository {
  /// Mengambil semua produk
  Future<Either<Failure, List<Produk>>> getAllProduk();

  /// Mengambil produk berdasarkan ID
  Future<Either<Failure, Produk>> getProdukById(String id);

  /// Mencari produk berdasarkan query
  Future<Either<Failure, List<Produk>>> searchProduk(String query);

  /// Mengambil semua minuman
  Future<Either<Failure, List<Produk>>> getMinuman();

  /// Mencari minuman berdasarkan query
  Future<Either<Failure, List<Produk>>> searchMinuman(String query);
}
