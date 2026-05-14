import 'package:hive/hive.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Box<TaskModel> _box;

  TaskRepositoryImpl(this._box);

  @override
  Future<List<Task>> loadTasks() async {
    final tasks = _box.values.map((model) => model.toTask()).toList();
    tasks.sort((a, b) => b.id.compareTo(a.id));
    return tasks;
  }

  @override
  Future<void> addTask(Task task) async {
    await _box.put(task.id, TaskModel.fromTask(task));
  }

  @override
  Future<void> updateTask(Task task) async {
    await _box.put(task.id, TaskModel.fromTask(task));
  }

  @override
  Future<void> deleteTask(int id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearDoneTasks() async {
    final doneKeys = _box.values
        .where((model) => model.done)
        .map((model) => model.id)
        .toList();
    await _box.deleteAll(doneKeys);
  }
}
