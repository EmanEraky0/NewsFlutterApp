import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.sourceName,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      sourceName: json['source']?['name'],
    );
  }
}