import 'package:news_flutter_app/features/news/domain/entities/article.dart';

import '../../domain/repositories/news_repository.dart';
import '../datasource/news_remote_datasource.dart';
import '../model/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remote;

  NewsRepositoryImpl(this.remote);

  @override
  Future<List<ArticleModel>> getAllArticles(int page) async {
    return await remote.fetchAllArticles(page: page);

  }


}