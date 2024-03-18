import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String category;
  final String name;
  final String date;
  final String publish;
  final String permalink;
  final DateTime createdAt;
  final String imageUrl;
  final int views;

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.name,
    required this.date,
    required this.publish,
    required this.permalink,
    required this.createdAt,
    required this.imageUrl,
    required this.views,
  });

  @override
  List<Object?> get props => [];
}
