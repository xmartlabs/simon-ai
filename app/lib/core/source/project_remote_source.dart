import 'package:simon_ai/core/model/project.dart';
import 'package:simon_ai/core/model/service/service_response.dart';
import 'package:simon_ai/core/source/common/http_service.dart';

class ProjectRemoteSource {
  static const _urlGetProjects = 'rest/v1/projects?select=*';

  final HttpServiceDio _httpService;

  ProjectRemoteSource(this._httpService);

  Future<List<Project>> getProjects() => _httpService
      .getAndProcessResponse(
        _urlGetProjects,
        serializer: (listResponse) => (listResponse as List)
            .map((project) => Project.fromJson(project))
            .toList(),
      )
      .then((value) => value.getDataOrThrow());
}
