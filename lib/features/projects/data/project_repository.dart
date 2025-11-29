import 'package:hive/hive.dart';
import 'project_model.dart';
import 'work_session_model.dart';

class ProjectRepository {
  final Box<Project> _projectBox;

  ProjectRepository(this._projectBox);

  // Get all projects
  List<Project> getProjects() {
    return _projectBox.values.toList();
  }

  // Add new project
  Future<void> addProject(Project project) async {
    await _projectBox.put(project.id, project);
  }

  // Delete project
  Future<void> deleteProject(String id) async {
    await _projectBox.delete(id);
  }

  // Update project (rename, sessions update, etc.)
  Future<void> updateProject(Project updatedProject) async {
    await _projectBox.put(updatedProject.id, updatedProject);
  }

  // Add a new session to a project
  Future<void> addSession(String projectId, WorkSession session) async {
    final project = _projectBox.get(projectId);

    if (project == null) return;

    final updated = Project(
      id: project.id,
      name: project.name,
      sessions: [...project.sessions, session],
    );

    await _projectBox.put(projectId, updated);
  }
}
