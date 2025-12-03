/// Generic UseCase base to standardize usecase signatures for TDD
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
