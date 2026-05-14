import 'package:flutter/material.dart';

import 'core/hive_service.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/task_use_cases.dart';
import 'presentation/screens/todo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  final taskUseCases = TaskUseCases(
    TaskRepositoryImpl(HiveService.tasksBox),
  );

  runApp(MyApp(taskUseCases: taskUseCases));
}

class MyApp extends StatelessWidget {
  final TaskUseCases taskUseCases;

  const MyApp({super.key, required this.taskUseCases});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF090A0C),
        cardColor: const Color(0xFF121417),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1F8EF1),
          secondary: Color(0xFF1F8EF1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF090A0C),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color(0xFF121417),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          hintStyle:
              const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.65)),
        ),
      ),
      home: TodoScreen(taskUseCases: taskUseCases),
    );
  }
}
