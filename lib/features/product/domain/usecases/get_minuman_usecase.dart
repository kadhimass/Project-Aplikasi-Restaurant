import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/product/domain/repositories/produk_repository.dart';

class GetMinumanUseCase {
  final ProdukRepository repository;

  GetMinumanUseCase(this.repository);

  Future<Either<Failure, List<Produk>>> call() async {
    return await repository.getMinuman();
  }
}
