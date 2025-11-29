import 'package:hive/hive.dart';

part 'work_session_model.g.dart';

@HiveType(typeId: 1)
class WorkSession {
  @HiveField(0)
  final DateTime start;

  @HiveField(1)
  final DateTime end;

  WorkSession({required this.start, required this.end});

  Duration get duration => end.difference(start);
}
