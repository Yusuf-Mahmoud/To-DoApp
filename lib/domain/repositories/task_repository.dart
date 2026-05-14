import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> loadTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
  Future<void> clearDoneTasks();
}
