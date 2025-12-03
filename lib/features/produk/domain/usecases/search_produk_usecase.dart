import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';
import 'package:menu_makanan/features/produk/domain/repositories/produk_repository.dart';

/// UseCase: Search produk berdasarkan query
/// Mengenkapsulasi business logic untuk search produk
class SearchProdukUseCase {
  final ProdukRepository repository;

  SearchProdukUseCase(this.repository);

  /// Execute usecase dengan query pencarian
  Future<Either<Failure, List<ProdukEntity>>> call(String query) async {
    if (query.isEmpty) {
      return await repository.getAllProduk();
    }
    return await repository.searchProduk(query);
  }
}
