import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../controllers/project_providers.dart';
import 'widgets/add_project_dialog.dart';
import 'package:chronowork/features/projects/presentation/project_detail_screen.dart';
import 'package:chronowork/features/projects/presentation/widgets/show_info_dialog.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectControllerProvider);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurpleAccent.shade200,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            "Add Project",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddProjectDialog(),
            );
          },
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ChronoWork",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.95),
                    letterSpacing: 0.6,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    showInfoDialog(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),

          Expanded(
            child: projects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 240.w,
                          width: 240.w,
                          child: Lottie.asset(
                            'assets/animations/no_data.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No projects yet.\nTap 'Add Project' to begin.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.sp,
                            height: 1.4.h,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 8.h,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (_, index) {
                      final project = projects[index];
                      return Dismissible(
                        key: Key(project.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28.w,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: const Color(0xff1A2A4A),
                                title: const Text(
                                  "Delete Project?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                  "Are you sure you want to delete '${project.name}'?",
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
                              .deleteProject(project.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Deleted '${project.name}'"),
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProjectDetailScreen(project: project),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF182A52),
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurpleAccent.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.folder_rounded,
                                      color: Colors.deepPurpleAccent,
                                      size: 24.w,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Text(
                                      project.name,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
