import '../../../../core/network/api_client.dart';
import '../model/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> fetchAllArticles({required int page});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiClient dio;
  NewsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ArticleModel>> fetchAllArticles({required int page}) async {

    final response = await dio.get(
      '/everything',
      queryParameters: {
        'domains': 'wsj.com',
        'page': page,
        'pageSize': 20,
        'apiKey': '21f88b271545498b871f75adffd0c709',
      },
    );


    final articles = response['articles'] as List;
    return articles.map((e) => ArticleModel.fromJson(e)).toList();
  }


}
