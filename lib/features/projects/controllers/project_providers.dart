import 'package:hive/hive.dart';
import 'timer_controller.dart';
import 'project_controller.dart';
import '../data/project_model.dart';
import '../data/project_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerControllerProvider = NotifierProvider<TimerController, TimerState>(
  TimerController.new,
);

final projectControllerProvider =
    NotifierProvider<ProjectController, List<Project>>(ProjectController.new);

final projectBoxProvider = Provider<Box<Project>>((ref) {
  return Hive.box<Project>('projects_box');
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final box = ref.watch(projectBoxProvider);
  return ProjectRepository(box);
});
