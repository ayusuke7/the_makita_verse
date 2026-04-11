import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data.dart';
import '../domain/domain.dart';
import '../views/views.dart';

final it = GetIt.instance;

void setupDI() {
  // External
  it.registerSingletonAsync<SharedPreferences>(SharedPreferences.getInstance);

  // DataSources
  it.registerLazySingleton<NewsLetterDataSource>(
    () => NewsLetterDataSourceImpl(it<SharedPreferences>()),
  );
  it.registerLazySingleton<BlogDataSource>(
    () => BlogDataSourceImpl(it<SharedPreferences>()),
  );
  it.registerLazySingleton<YoutubeDataSource>(
    () => YoutubeDataSourceImpl(),
  );

  // Repositories
  it.registerLazySingleton<NewsLetterRepository>(
    () => NewsLetterRepositoryImpl(it<NewsLetterDataSource>()),
  );
  it.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(it<BlogDataSource>()),
  );
  it.registerLazySingleton<YoutubeRepository>(
    () => YoutubeRepositoryImpl(it<YoutubeDataSource>()),
  );

  // ViewModels
  it.registerLazySingleton<ArticlesPageViewModel>(
    () => ArticlesPageViewModel(it<NewsLetterRepository>()),
  );
  it.registerLazySingleton<PostsPageViewModel>(
    () => PostsPageViewModel(it<BlogRepository>()),
  );
  it.registerLazySingleton<PodcastsViewModel>(
    () => PodcastsViewModel(it<NewsLetterRepository>()),
  );
  it.registerLazySingleton<ChannelViewModel>(
    () => ChannelViewModel(it<YoutubeRepository>()),
  );
}
