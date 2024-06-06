import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/project.dart';
import 'package:simon_ai/core/repository/project_repository.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

part 'welcome_cubit.freezed.dart';
part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeBaseState> {
  final SessionRepository _sessionRepository = DiProvider.get();
  final ProjectRepository _projectRepository = DiProvider.get();

  final GlobalEventHandler _globalEventHandler;

  StreamSubscription? _projectsSubscription;

  WelcomeCubit(this._globalEventHandler)
      : super(const WelcomeBaseState.state()) {
    _initStreams();
  }

  void _initStreams() {
    _projectsSubscription = _projectRepository
        .getProjects()
        .filterSuccess(_globalEventHandler.handleError)
        .listen((projects) => emit(state.copyWith(projects: projects ?? [])));
  }

  @override
  Future<void> close() async {
    await _projectsSubscription?.cancel();
    await super.close();
  }

  Future<void> logOut() => _sessionRepository.logOut().mapToResult();
}
