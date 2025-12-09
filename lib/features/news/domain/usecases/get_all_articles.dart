import 'package:news_flutter_app/features/news/data/repositoriesImpl/news_repository_impl.dart';
import '../../data/model/article_model.dart';

class GetAllArticles {
  final NewsRepositoryImpl repository;
  GetAllArticles(this.repository);

  Future<List<ArticleModel>> call(int page) => repository.getAllArticles(page);


}