import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/project_model.dart';
import '../data/work_session_model.dart';
import '../data/project_repository.dart';
import 'project_providers.dart';

class ProjectController extends Notifier<List<Project>> {
  late final ProjectRepository _repository;

  @override
  List<Project> build() {
    _repository = ref.read(projectRepositoryProvider);
    return _repository.getProjects();
  }

  void addProject(String name) async {
    final id = const Uuid().v4();

    final project = Project(id: id, name: name, sessions: []);

    await _repository.addProject(project);
    state = _repository.getProjects();
  }

  void deleteProject(String id) async {
    await _repository.deleteProject(id);
    state = _repository.getProjects();
  }

  void addSession(String projectId, WorkSession session) async {
    await _repository.addSession(projectId, session);
    state = _repository.getProjects();
  }

  void deleteSession(String projectId, int sessionIndex) async {
    await _repository.deleteSession(projectId, sessionIndex);
    state = _repository.getProjects();
  }
}
