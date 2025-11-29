import 'package:flutter/material.dart';
import 'package:chronowork/services/hive_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chronowork/features/projects/presentation/project_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChronoWork',

          // -------------------- GLOBAL THEME -------------------- //
          theme: ThemeData(
            useMaterial3: true,

            // Background color for all screens
            scaffoldBackgroundColor: const Color(0xff0E1D3E),

            // Global ColorScheme
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),

            // AppBar styling
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff0E1D3E),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Global text styling
            textTheme: const TextTheme(
              displayMedium: TextStyle(color: Colors.white, fontSize: 18),
              displaySmall: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          home: const ProjectListScreen(),
        );
      },
    );
  }
}
