import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetWelcomeMessage {
  final HomeRepository repository;
  GetWelcomeMessage(this.repository);

  Future<HomeEntity> call() async {
    return await repository.getWelcomeMessage();
  }
} 