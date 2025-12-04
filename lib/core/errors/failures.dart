import 'package:equatable/equatable.dart';

/// Abstract Failure class for domain errors
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
