abstract class HomeDataSource {
  Future<String> fetchWelcomeMessage();
}

class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<String> fetchWelcomeMessage() async {
    await Future.delayed(Duration(seconds: 1));
    return "Hoşgeldiniz!";
  }
} 