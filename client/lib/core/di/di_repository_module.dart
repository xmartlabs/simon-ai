import 'package:get_it/get_it.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/interfaces/permission_handler_interface.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/repository/game_manager.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/core/repository/user_repository.dart';
import 'package:simon_ai/core/services/permission_handler_service.dart';
import 'package:simon_ai/core/source/auth_local_source.dart';
import 'package:simon_ai/core/source/auth_remote_source.dart';
import 'package:simon_ai/core/source/common/auth_interceptor.dart';
import 'package:simon_ai/core/source/common/http_service.dart';
import 'package:simon_ai/core/source/project_local_source.dart';
import 'package:simon_ai/core/source/project_remote_source.dart';
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
    registerLazySingleton(() => HttpServiceDio([AuthInterceptor(get())]));
    registerLazySingleton<PermissionHandlerInterface>(
      () => MobilePermissionHandlerService(),
    );
    registerLazySingleton<UserRemoteSource>(
      () => UserRemoteSource(
        modelToJson: (User data) => data.toJson(),
        jsonToModel: User.fromJson,
        collection: Config.userCollection,
      ),
    );
  }

  void _setupRepositories() {
    registerLazySingleton(() => SessionRepository(get(), get()));
    registerLazySingleton(() => UserRepository(get()));
    registerLazySingleton(() => GameManager());
  }

  void _setupSources() {
    registerLazySingleton(() => AuthLocalSource(get()));
    registerLazySingleton(() => AuthRemoteSource(get()));
    registerLazySingleton(() => ProjectLocalSource());
    registerLazySingleton(() => ProjectRemoteSource(get()));
  }
}
