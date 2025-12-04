import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/product/domain/repositories/produk_repository.dart';
import 'package:menu_makanan/features/product/domain/usecases/get_all_produk_usecase.dart';

class MockRepo implements ProdukRepository {
  @override
  Future<Either<Failure, List<Produk>>> getAllProduk() async {
    return Right([]);
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('debug test - usecase', () async {
    final repo = MockRepo();
    final usecase = GetAllProdukUseCase(repo);
    final result = await usecase();
    expect(result.isRight(), true);
  });
}
