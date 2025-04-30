import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/get_welcome_message.dart';
import '../../data/datasources/home_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';

class HomeProvider extends ChangeNotifier {
  final GetWelcomeMessage getWelcomeMessage;
  String? message;
  bool loading = true;

  HomeProvider(this.getWelcomeMessage) {
    loadMessage();
  }

  Future<void> loadMessage() async {
    final entity = await getWelcomeMessage();
    message = entity.welcomeMessage;
    loading = false;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final dataSource = HomeDataSourceImpl();
        final repository = HomeRepositoryImpl(dataSource);
        final usecase = GetWelcomeMessage(repository);
        return HomeProvider(usecase);
      },
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home Page')),
            body: Center(
              child: provider.loading
                  ? const CircularProgressIndicator()
                  : Text(provider.message ?? ''),
            ),
          );
        },
      ),
    );
  }
} 