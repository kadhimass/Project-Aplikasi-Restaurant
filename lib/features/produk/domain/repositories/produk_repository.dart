import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';

/// Abstract Repository Interface untuk Produk
/// Mendefinisikan contract yang harus diimplementasikan oleh repository konkret
abstract class ProdukRepository {
  /// Fetch semua produk dari data source
  Future<Either<Failure, List<ProdukEntity>>> getAllProduk();

  /// Fetch produk berdasarkan ID
  Future<Either<Failure, ProdukEntity>> getProdukById(String id);

  /// Search produk berdasarkan nama
  Future<Either<Failure, List<ProdukEntity>>> searchProduk(String query);

  /// Fetch semua minuman
  Future<Either<Failure, List<ProdukEntity>>> getMinuman();

  /// Search minuman berdasarkan nama
  Future<Either<Failure, List<ProdukEntity>>> searchMinuman(String query);
}
