import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';
import 'package:menu_makanan/features/produk/domain/repositories/produk_repository.dart';

class GetAllMinumanUseCase {
  final ProdukRepository repository;

  GetAllMinumanUseCase(this.repository);

  Future<Either<Failure, List<ProdukEntity>>> call() async {
    return await repository.getMinuman();
  }
}
