import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/task_use_cases.dart';
import '../widgets/filter_bar.dart';
import '../widgets/task_input.dart';
import '../widgets/task_item.dart';

class TodoScreen extends StatefulWidget {
  final TaskUseCases taskUseCases;

  const TodoScreen({super.key, required this.taskUseCases});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  int _nextId = 1;
  bool _loading = true;

  List<Task> get _filteredTasks {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.done).toList();
      case TaskFilter.done:
        return _tasks.where((task) => task.done).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  int get _doneCount => _tasks.where((task) => task.done).length;
  int get _activeCount => _tasks.where((task) => !task.done).length;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.taskUseCases.loadTasks();
    setState(() {
      _tasks
        ..clear()
        ..addAll(tasks);
      _nextId =
          tasks.isEmpty ? 1 : tasks.map((task) => task.id).reduce(math.max) + 1;
      _loading = false;
    });
  }

  Future<void> _addTask() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final task = Task(id: _nextId++, text: text);
    await widget.taskUseCases.addTask(task);

    setState(() {
      _tasks.insert(0, task);
      _controller.clear();
    });
  }

  Future<void> _toggleTask(int id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index < 0) return;

    final task = _tasks[index];
    final updated = task.copyWith(done: !task.done);
    await widget.taskUseCases.updateTask(updated);

    setState(() {
      _tasks[index] = updated;
    });
  }

  Future<void> _deleteTask(int id) async {
    await widget.taskUseCases.deleteTask(id);
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  Future<void> _clearDone() async {
    await widget.taskUseCases.clearDoneTasks();
    setState(() {
      _tasks.removeWhere((task) => task.done);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A0C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'To-Do List',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _loading
                            ? 'Loading your tasks...'
                            : _tasks.isEmpty
                                ? 'Start by adding a new task'
                                : '$_activeCount active • $_doneCount done',
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _clearDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F8EF1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                    ),
                    child: const Text('Clear Done'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            TaskInput(controller: _controller, onAdd: _addTask),
            FilterBar(
              selectedFilter: _filter,
              onFilterChanged: (value) {
                setState(() => _filter = value);
              },
            ),
            const SizedBox(height: 4),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1F8EF1),
                      ),
                    )
                  : _filteredTasks.isEmpty
                      ? Center(
                          child: Text(
                            _tasks.isEmpty
                                ? 'No tasks yet. Add one above.'
                                : 'No tasks here for this filter.',
                            style: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.7),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 4, bottom: 16),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = _filteredTasks[index];
                            return TaskItem(
                              task: task,
                              onToggle: (_) => _toggleTask(task.id),
                              onDelete: () => _deleteTask(task.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
