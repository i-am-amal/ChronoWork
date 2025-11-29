import 'dart:async';
import 'package:chronowork/features/projects/controllers/project_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/work_session_model.dart';

// ---------------- TIMER STATE ---------------- //

class TimerState {
  final bool isRunning;
  final String? activeProjectId;
  final DateTime? startTime;
  final Duration elapsed;

  TimerState({
    required this.isRunning,
    required this.activeProjectId,
    required this.startTime,
    required this.elapsed,
  });

  TimerState.initial()
    : isRunning = false,
      activeProjectId = null,
      startTime = null,
      elapsed = Duration.zero;

  TimerState copyWith({
    bool? isRunning,
    String? activeProjectId,
    DateTime? startTime,
    Duration? elapsed,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      activeProjectId: activeProjectId ?? this.activeProjectId,
      startTime: startTime ?? this.startTime,
      elapsed: elapsed ?? this.elapsed,
    );
  }
}

// ---------------- TIMER CONTROLLER ---------------- //

class TimerController extends Notifier<TimerState> {
  Timer? _timer;

  @override
  TimerState build() {
    ref.keepAlive();
    return TimerState.initial();
  }

  // Start timer for a specific project
  void start(String projectId) {
    if (state.isRunning) return;

    final start = DateTime.now();

    state = state.copyWith(
      isRunning: true,
      activeProjectId: projectId,
      startTime: start,
      elapsed: Duration.zero,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        elapsed: DateTime.now().difference(state.startTime!),
      );
    });
  }

  // Stop timer and save session to the correct project
  void stop() {
    if (!state.isRunning) return;

    _timer?.cancel();

    final end = DateTime.now();
    final session = WorkSession(start: state.startTime!, end: end);

    final projectId = state.activeProjectId!;
    ref.read(projectControllerProvider.notifier).addSession(projectId, session);

    state = TimerState.initial();
  }
}
