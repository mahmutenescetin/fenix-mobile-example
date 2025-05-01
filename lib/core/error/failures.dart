abstract class Failure {
  final String message;
  final int? code;

  Failure({required this.message, this.code});
}

class ServerFailure extends Failure {
  ServerFailure({required String message, int? code}) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  CacheFailure({required String message}) : super(message: message);
} 