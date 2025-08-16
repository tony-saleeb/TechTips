import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Data layer
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/tip_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';

// Domain layer
import '../../domain/repositories/tip_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_tips_by_os_usecase.dart';
import '../../domain/usecases/search_tips_usecase.dart';
import '../../domain/usecases/manage_favorites_usecase.dart';
import '../../domain/usecases/manage_settings_usecase.dart';

// Presentation layer
import '../viewmodels/app_viewmodel.dart';
import '../viewmodels/tips_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';

/// Dependency injection setup for the app
class DependencyInjection {
  /// Get all providers for the app
  static List<SingleChildWidget> getProviders() {
    return [
      // Data Sources
      Provider<LocalDataSource>(
        create: (_) => LocalDataSource(),
      ),
      
      // Repositories
      ProxyProvider<LocalDataSource, TipRepository>(
        update: (_, localDataSource, __) => TipRepositoryImpl(localDataSource),
      ),
      ProxyProvider<LocalDataSource, SettingsRepository>(
        update: (_, localDataSource, __) => SettingsRepositoryImpl(localDataSource),
      ),
      
      // Use Cases
      ProxyProvider<TipRepository, GetTipsByOSUseCase>(
        update: (_, repository, __) => GetTipsByOSUseCase(repository),
      ),
      ProxyProvider<TipRepository, SearchTipsUseCase>(
        update: (_, repository, __) => SearchTipsUseCase(repository),
      ),
      ProxyProvider<TipRepository, ManageFavoritesUseCase>(
        update: (_, repository, __) => ManageFavoritesUseCase(repository),
      ),
      ProxyProvider<SettingsRepository, ManageSettingsUseCase>(
        update: (_, repository, __) => ManageSettingsUseCase(repository),
      ),
      
      // ViewModels
      ChangeNotifierProvider<AppViewModel>(
        create: (_) => AppViewModel(),
      ),
      ChangeNotifierProxyProvider3<GetTipsByOSUseCase, SearchTipsUseCase, ManageFavoritesUseCase, TipsViewModel>(
        create: (context) => TipsViewModel(
          getTipsByOSUseCase: context.read<GetTipsByOSUseCase>(),
          searchTipsUseCase: context.read<SearchTipsUseCase>(),
          manageFavoritesUseCase: context.read<ManageFavoritesUseCase>(),
        ),
        update: (_, getTipsUseCase, searchUseCase, favoritesUseCase, previous) {
          return previous ?? TipsViewModel(
            getTipsByOSUseCase: getTipsUseCase,
            searchTipsUseCase: searchUseCase,
            manageFavoritesUseCase: favoritesUseCase,
          );
        },
      ),
      ChangeNotifierProxyProvider<ManageSettingsUseCase, SettingsViewModel>(
        create: (context) => SettingsViewModel(
          manageSettingsUseCase: context.read<ManageSettingsUseCase>(),
        ),
        update: (_, settingsUseCase, previous) {
          return previous ?? SettingsViewModel(
            manageSettingsUseCase: settingsUseCase,
          );
        },
      ),
    ];
  }
}
