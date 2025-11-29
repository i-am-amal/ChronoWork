import 'package:chronowork/features/projects/data/project_model.dart';
import 'package:chronowork/features/projects/data/work_session_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProjectAdapter());
    Hive.registerAdapter(WorkSessionAdapter());
    await Hive.openBox<Project>('projects_box');
  }
}
