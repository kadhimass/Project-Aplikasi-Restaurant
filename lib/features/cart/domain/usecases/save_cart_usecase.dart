import 'package:menu_makanan/core/usecase.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
import 'package:menu_makanan/features/cart/domain/repositories/cart_repository.dart';

class SaveCartUsecase extends UseCase<void, Cart> {
  final CartRepository repository;

  SaveCartUsecase(this.repository);

  @override
  Future<void> call(Cart params) async {
    await repository.saveCart(params);
  }
}
