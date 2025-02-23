import 'package:get_it/get_it.dart';
import 'package:simon_ai/core/interfaces/permission_handler_interface.dart';
import 'package:simon_ai/core/repository/game_manager.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/core/repository/player_repository.dart';
import 'package:simon_ai/core/services/firebase_auth.dart';
import 'package:simon_ai/core/services/permission_handler_service.dart';
import 'package:simon_ai/core/source/auth_local_source.dart';
import 'package:simon_ai/core/source/auth_remote_source.dart';
import 'package:simon_ai/core/source/user_remote_source.dart';

class RepositoryDiModule {
  RepositoryDiModule._privateConstructor();

  static final RepositoryDiModule _instance =
      RepositoryDiModule._privateConstructor();

  factory RepositoryDiModule() => _instance;

  void setupModule(GetIt locator) {
    locator
      .._setupProvidersAndUtils()
      .._setupSources()
      .._setupRepositories();
  }
}

extension _GetItDiModuleExtensions on GetIt {
  void _setupProvidersAndUtils() {
    registerLazySingleton(() => FirebaseAuthService());
    registerLazySingleton<PermissionHandlerInterface>(
      () => MobilePermissionHandlerService(),
    );
  }

  void _setupRepositories() {
    registerLazySingleton(() => SessionRepository(get(), get(), get()));
    registerLazySingleton(() => PlayerRepository(get(), get()));
    registerLazySingleton(() => GameManager(get()));
  }

  void _setupSources() {
    registerLazySingleton(() => AuthLocalSource(get()));
    registerLazySingleton(() => AuthRemoteSource(get()));

    registerLazySingleton<UserRemoteSource>(() => UserRemoteSource());
  }
}
