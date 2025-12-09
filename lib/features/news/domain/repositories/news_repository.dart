import '../../data/model/article_model.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  Future<List<ArticleModel>> getAllArticles(int page);
}
