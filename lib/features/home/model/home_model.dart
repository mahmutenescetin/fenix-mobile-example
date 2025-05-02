class HomeModel {
  final int id;
  final String title;
  final String description;

  HomeModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
} 