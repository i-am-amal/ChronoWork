import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/project_providers.dart';
import '../controllers/timer_controller.dart';
import '../../projects/data/project_model.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectControllerProvider);
    final updatedProject = projects.firstWhere(
      (p) => p.id == project.id,
      orElse: () => project,
    );
    final timer = ref.watch(timerControllerProvider);
    final bool isThisProjectRunning =
        timer.isRunning && timer.activeProjectId == updatedProject.id;
    return Scaffold(
      backgroundColor: const Color(0xff0E1D3E),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.h),
        child: Container(
          padding: EdgeInsets.only(top: 40.h, left: 12.w, right: 12.w),
          decoration: const BoxDecoration(color: Color(0xff0E1D3E)),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 4.w),
              Text(
                updatedProject.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          _buildTimerSection(
            context,
            ref,
            timer,
            isThisProjectRunning,
            updatedProject.id,
            projects,
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.white70, size: 22.sp),
                SizedBox(width: 10.w),
                Text(
                  "Total Time: ${_formatTotalDuration(updatedProject.sessions)}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 18.h),

          // ---------------- SESSIONS TITLE ---------------- //
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Text(
              "Sessions",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // ---------------- SESSION LIST ---------------- //
          Expanded(
            child: updatedProject.sessions.isEmpty
                ? const Center(
                    child: Text(
                      "No sessions yet",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 10.h,
                    ),
                    itemCount: updatedProject.sessions.length,
                    itemBuilder: (_, index) {
                      final session = updatedProject.sessions[index];

                      return Dismissible(
                        key: Key("${updatedProject.id}_session_$index"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: EdgeInsets.only(bottom: 14.h),
                          padding: EdgeInsets.only(right: 20.w),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: const Color(0xff1A2A4A),
                                title: const Text(
                                  "Delete Session?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                  "Are you sure you want to delete this session?",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (_) {
                          ref
                              .read(projectControllerProvider.notifier)
                              .deleteSession(updatedProject.id, index);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Session deleted")),
                          );
                        },

                        child: _buildSessionCard(session),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ------------------ TIMER SECTION UI ------------------ //

  Widget _buildTimerSection(
    BuildContext context,
    WidgetRef ref,
    TimerState timer,
    bool isThisProjectRunning,
    String projectId,
    List<Project> allProjects,
  ) {
    if (isThisProjectRunning) {
      return Column(
        children: [
          Text(
            "⏱ ${_formatDuration(timer.elapsed)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton.icon(
            icon: const Icon(Icons.stop),
            label: const Text("Stop Timer"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              ref.read(timerControllerProvider.notifier).stop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Timer stopped and session saved"),
                ),
              );
            },
          ),
        ],
      );
    }

    return ElevatedButton.icon(
      icon: const Icon(Icons.play_arrow),
      label: const Text("Start Timer"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      onPressed: () {
        if (timer.isRunning && timer.activeProjectId != projectId) {
          final runningProject = allProjects.firstWhere(
            (p) => p.id == timer.activeProjectId,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Timer already running on '${runningProject.name}'. Stop it first.",
              ),
            ),
          );
          return;
        }

        ref.read(timerControllerProvider.notifier).start(projectId);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Timer started")));
      },
    );
  }

  // ------------------ SESSION CARD UI ------------------ //

  Widget _buildSessionCard(session) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF182A52),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.white70, size: 24.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(session.start),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${_formatTime(session.start)} → ${_formatTime(session.end)}",
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          Text(
            _formatDuration(session.duration),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ HELPERS ------------------ //

  String _formatDate(DateTime dt) => "${dt.day}/${dt.month}/${dt.year}";

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  String _formatTotalDuration(List sessions) {
    Duration total = Duration.zero;
    for (final s in sessions) {
      total += s.duration;
    }
    return _formatDuration(total);
  }
}
