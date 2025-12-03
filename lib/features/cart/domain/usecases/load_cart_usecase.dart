import 'package:menu_makanan/core/usecase.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
import 'package:menu_makanan/features/cart/domain/repositories/cart_repository.dart';

class LoadCartUsecase extends UseCase<Cart, NoParams> {
  final CartRepository repository;

  LoadCartUsecase(this.repository);

  @override
  Future<Cart> call(NoParams params) async {
    return await repository.loadCart();
  }
}
