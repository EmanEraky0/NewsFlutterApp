import 'package:flutter/cupertino.dart';
import 'package:news_flutter_app/core/error/failures.dart';
import 'package:news_flutter_app/features/news/domain/usecases/get_all_articles.dart';
import '../../../../core/ui_result.dart';
import '../../data/model/article_model.dart';


class NewsProvider extends ChangeNotifier {
  final GetAllArticles useCase;

  UiResult<List<ArticleModel>> state = UiLoading();
  final List<ArticleModel> articles = [];
  int page = 1;
  bool isLoadingMore = false;

  NewsProvider(this.useCase);

  Future<void> loadInitial() async {
    state = UiLoading();
    notifyListeners();

    try {
      page = 1;
      articles.clear();
      final res = await useCase.call(page);
      articles.addAll(res);
      state = UiSuccess(articles);
    } catch (e) {
      state = UiError(Failure(e.toString()));
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    page++;
    notifyListeners();

    try {
      final res = await useCase.call(page);
      articles.addAll(res);
      state = UiSuccess(articles);
    } catch (e) {
      state = UiError(Failure(e.toString()));
    }

    isLoadingMore = false;
    notifyListeners();
  }
}

