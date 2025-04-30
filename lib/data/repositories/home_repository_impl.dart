import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;
  HomeRepositoryImpl(this.dataSource);

  @override
  Future<HomeEntity> getWelcomeMessage() async {
    final message = await dataSource.fetchWelcomeMessage();
    return HomeEntity(welcomeMessage: message);
  }
} 