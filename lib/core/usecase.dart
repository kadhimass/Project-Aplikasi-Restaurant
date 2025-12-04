/// Generic UseCase base to standardize usecase signatures for TDD
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

class NoParams {}
