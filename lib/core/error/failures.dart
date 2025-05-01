abstract class Failure {
  final String message;
  final int? code;

  Failure({required this.message, this.code});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
} 