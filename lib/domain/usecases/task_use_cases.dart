import '../entities/task.dart';
import '../repositories/task_repository.dart';

class TaskUseCases {
  final TaskRepository repository;

  TaskUseCases(this.repository);

  Future<List<Task>> loadTasks() => repository.loadTasks();
  Future<void> addTask(Task task) => repository.addTask(task);
  Future<void> updateTask(Task task) => repository.updateTask(task);
  Future<void> deleteTask(int id) => repository.deleteTask(id);
  Future<void> clearDoneTasks() => repository.clearDoneTasks();
}
