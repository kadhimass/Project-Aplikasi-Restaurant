import 'package:menu_makanan/core/usecase.dart';
import 'package:menu_makanan/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUsecase extends UseCase<void, NoParams> {
  final CartRepository repository;

  ClearCartUsecase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    await repository.clearCart();
  }
}
