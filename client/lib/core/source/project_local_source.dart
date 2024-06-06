import 'package:simon_ai/core/model/project.dart';
import 'package:simon_ai/core/source/common/hive_base_source.dart';

class ProjectLocalSource extends HiveBaseSource<int, Project> {
  ProjectLocalSource()
      : super(
          dbParser: (project) => project.toJson(),
          modelParser: (project) => Project.fromJson(project),
        );

  Future<List<Project>> replaceProjects(List<Project> elements) async {
    await deleteAllElements();
    return putAllElements(
      Map.fromEntries(
        elements.map(
          (e) => MapEntry(e.id, e),
        ),
      ),
    );
  }
}
