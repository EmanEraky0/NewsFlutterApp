import 'package:get_it/get_it.dart';
import 'package:news_flutter_app/features/news/domain/usecases/get_all_articles.dart';

import '../core/network/api_client.dart';
import '../features/news/data/datasource/news_remote_datasource.dart';
import '../features/news/data/repositoriesImpl/news_repository_impl.dart';

final sl = GetIt.instance;

void initDependencies() {

// ApiClient
  sl.registerLazySingleton(() => ApiClient());

// DataSource
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl( dio: sl<ApiClient>()));

// Repository
  sl.registerLazySingleton(() => NewsRepositoryImpl(sl()));

// UseCase
  sl.registerLazySingleton(() => GetAllArticles(sl()));
}
