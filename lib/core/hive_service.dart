import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/task_model.dart';

class HiveService {
  static const String tasksBoxName = 'tasks_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    await Hive.openBox<TaskModel>(tasksBoxName);
  }

  static Box<TaskModel> get tasksBox => Hive.box<TaskModel>(tasksBoxName);
}
