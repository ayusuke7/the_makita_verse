import 'package:core/core.dart';

import '../views/views.dart';

final it = GetIt.instance;

void setupDI() {
  // External
  // it.registerSingleton<SupabaseClient>(Supabase.instance.client);
  it.registerSingletonAsync<SharedPreferences>(SharedPreferences.getInstance);

  // DataSources
  it.registerLazySingleton<NewsLetterDataSource>(
    () => NewsLetterDataSourceImpl(it<SharedPreferences>()),
  );
  it.registerLazySingleton<BlogDataSource>(
    () => BlogDataSourceImpl(),
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
  it.registerLazySingleton<BlogPageViewModel>(
    () => BlogPageViewModel(it<BlogRepository>()),
  );
  it.registerLazySingleton<PodcastsViewModel>(
    () => PodcastsViewModel(it<NewsLetterRepository>()),
  );
  it.registerLazySingleton<ChannelViewModel>(
    () => ChannelViewModel(it<YoutubeRepository>()),
  );
}
