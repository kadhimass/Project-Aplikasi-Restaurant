import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/product/domain/repositories/produk_repository.dart';

/// UseCase: Search produk berdasarkan query
/// Mengenkapsulasi business logic untuk search produk
class SearchProdukUseCase {
  final ProdukRepository repository;

  SearchProdukUseCase(this.repository);

  /// Execute usecase dengan query pencarian
  Future<Either<Failure, List<Produk>>> call(String query) async {
    return await repository.searchProduk(query);
  }
}
